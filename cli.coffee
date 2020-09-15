#!/usr/bin/env iced
fs = require "fs"
require "fy"
wasm = require "wasm"
{parse} = require "./src/parser"
{transform} = require "./src/ast_transform"
translate_c = require "./src/translate_c"
argv = require("minimist")(process.argv.slice(2))
if !argv._[0]
  p "usage ./cli.coffee <src_file.clar>"
  p "default destination is ./build/compiled.js"
  process.exit()

for k,v of argv
  argv[k.replace(/-/g, "_")] = v

code = fs.readFileSync argv._[0], "utf-8"
ret_ast = parse code
ret_ast = transform(ret_ast, {code})
ret_c = translate_c.gen ret_ast
fs.writeFileSync "build/mod/index.c", ret_c
# ###################################################################################################
#    wasm magic
# ###################################################################################################
opt = {
  dir : "build/lib"
  seq : true
  drop_clang_warning : false
}
await wasm.lib_compile opt, defer(err); throw err if err

opt = {
  dir : "build/mod"
  obj_list : fs.readdirSync("build/lib/build").map (t)->"build/lib/build/#{t}"
  seq : true
  drop_clang_warning : false
  use_wasm_runtime : false
}
await wasm.mod_compile opt, defer(err); throw err if err
# ###################################################################################################
#    generate wrapper
# ###################################################################################################
wasm_buf = fs.readFileSync "./build/mod/index.wasm"

jl = []
# expect scope
for fn_decl_ast in ret_ast.list
  continue if fn_decl_ast.constructor.name != "Fn_decl"
  fn_name = translate_c.translate_var_name fn_decl_ast.name, {}
  arg_check_jl = []
  
  arg_list = []
  for arg, idx in fn_decl_ast.arg_name_list
    arg_name = translate_c.translate_var_name arg, {}
    arg_list.push "action.input.#{arg_name}"
    
    type = fn_decl_ast.type.nest_list[idx+1]
    switch type.main
      when "int"
        arg_check_jl.push """
          tmp_val = action.input.#{arg_name};
          if (typeof tmp_val !== 'number' || !isFinite(tmp_val) || Math.round(tmp_val) != tmp_val) {
            throw new ContractError(`Invalid #{arg} provided: ${action.input.name}; Expect number (not NaN, not +-Infinity, integer)`)
          }
          """
      
      when "string"
        arg_check_jl.push """
          tmp_val = action.input.#{arg_name};
          if (typeof tmp_val !== 'string') {
            throw new ContractError(`Invalid #{arg} provided: ${action.input.name}; Expect number (not NaN, not +-Infinity, integer)`)
          }
          """
        
      
      else
        throw new Error "can't generate wrapper for function with argument type '#{type}'"
      
  
  jl.push """
    if (action.input.function === #{JSON.stringify fn_decl_ast.name}) {
      var tmp_val;
      #{join_list arg_check_jl, '  '}
      var result = instance.instance.exports.#{fn_name}(#{arg_list.join ', '})
      
      if (result) {
        return { state, result } // I don't know is that correct or not
        // return { result } // probably this is correct
      } else {
        return { state }
      }
    }
  """

handle_str = "export async function handle"

if argv.fix_export
  handle_str = "this.handle = async function"

code = """
var utf8decoder = new TextDecoder("utf-8")
const WASM_BUF = Buffer.from(#{JSON.stringify wasm_buf.toString 'base64'}, "base64");

#{handle_str} (state, action) {
  var memory;
  var wasm2string = function(s_pointer) {
    var iter, u8;
    // нельзя делать 1 раз, т.к. memory.buffer может поменяться и будет
    // Cannot perform %TypedArray%.prototype.slice on a neutered ArrayBuffer
    u8 = new Int8Array(memory.buffer);
    iter = s_pointer;
    while (u8[iter]) {
      iter++;
    }
    if (iter !== s_pointer) {
      return utf8decoder.decode(u8.subarray(s_pointer, iter));
    } else {
      return "";
    }
  };
  
  var import_object = {
    env: {
      user_throw: function(s_pointer) {
        var str= wasm2string(s_pointer);
        throw new Error(`wasm user_throw ${str}`);
      },
      logsi: function(s_pointer, i) {
        var str = wasm2string(s_pointer);
        return console.log(`${str} ${i}`);
      },
      putsi: function(s_pointer, i) {
        var str;
        str = wasm2string(s_pointer);
        return console.log(`${str} ${i}`);
      }
    }
  };
  
  instance = await WebAssembly.instantiate(WASM_BUF, import_object)
  
      memory        = instance.instance.exports.memory       ;
  var __heap_base   = instance.instance.exports.__heap_base  ;
  var __heap_set    = instance.instance.exports.__heap_set   ;
  var __alloc_init  = instance.instance.exports.__alloc_init ;
  var ws_malloc     = instance.instance.exports.ws_malloc    ;
  var LENGTH_OFFSET = instance.instance.exports.LENGTH_OFFSET;
  
  __heap_set(__heap_base)
  __alloc_init()
  
  #{join_list jl, '  '}
  
  throw new ContractError(`Unrecognized function: "${action.input.function}"`)
}
"""#"

fs.writeFileSync "./build/compiled.js", code
