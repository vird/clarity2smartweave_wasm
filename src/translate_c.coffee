module = @
require "fy/codegen"

@bin_op_name_map =
  ADD : "+"
  SUB : "-"
  MUL : "*"
  DIV : "/"
  MOD : "%"
  
  EQ  : "="
  NE  : "!="
  GT  : ">"
  LT  : "<"
  GTE : ">="
  LTE : "<="
  # POW : "LIGO_IMPLEMENT_ME_PLEASE_POW"
  
  BOOL_AND: "and"
  BOOL_OR : "or"

# @bin_op_name_cb_map = {}

# ###################################################################################################
class @Gen_context
  
  mk_nest : ()->
    ret = new module.Gen_context
    ret

translate_type = (type, ctx)->
  switch type.main
    when "_"
      throw new Error "no type inference/translation for type _"
    
    when "void"
      if !ctx.allow_void
        throw new Error "void type is not allowed"
      "void"
    # ###################################################################################################
    #    scalar
    # ###################################################################################################
    when "string"
      "char*"
    
    when "int"
      # WASM error
      # wasm function signature contains illegal type
      if ctx.is_arg
        "i32"
      else
        "i64"
    # ###################################################################################################
    #    collections
    # ###################################################################################################
    # TODO
    
    # ###################################################################################################
    else
      throw new Error "WARNING (Translate). translate_type unknown type '#{type}'"

@translate_var_name = translate_var_name = (name, ctx)->
  name.replace /-/g, "_"

walk = (root, ctx)->
  switch root.constructor.name
    when "Scope"
      jl = []
      for v in root.list
        t = walk v, ctx
        if t and t[t.length - 1] != ";"
          t += ";"
        jl.push t if t != ""
      if root.top_scope
        join_list jl, ""
      else
        """
        {
          #{join_list jl, '  '}
        }
        """
    # ###################################################################################################
    #    expr
    # ###################################################################################################
    when "Const"
      switch root.type.main
        when "bool", "int", "float"
          root.val
        when "string"
          JSON.stringify root.val
    
    when "Var"
      translate_var_name root.name, ctx
    
    when "Bin_op"
      _a = walk root.a, ctx
      _b = walk root.b, ctx
      ret = if op = module.bin_op_name_map[root.op]
        "(#{_a} #{op} #{_b})"
      # else if cb = module.bin_op_name_cb_map[root.op]
        # cb(_a, _b, ctx, root)
      else
        throw new Error "Unknown/unimplemented bin_op #{root.op}"
    # ###################################################################################################
    #    stmt
    # ###################################################################################################
    
    when "Ret"
      aux = ""
      if root.t
        aux = " (#{walk root.t, ctx})"
      "return#{aux};"
    
    when "Fn_decl"
      ctx_nest = ctx.mk_nest()
      
      ctx_tmp = ctx_nest.mk_nest()
      ctx_tmp.allow_void = true
      ctx_tmp.is_arg = true
      ret_type = translate_type root.type.nest_list[0], ctx_tmp
      
      arg_list = []
      for v, idx in root.arg_name_list
        ctx_tmp = ctx_nest.mk_nest()
        ctx_tmp.is_arg = true
        type = translate_type root.type.nest_list[idx+1], ctx_tmp
        arg_list.push "#{type} #{v}"
      
      scope = walk root.scope, ctx_nest
      name = translate_var_name root.name, ctx
      """
      __attribute__((visibility("default")))
      #{ret_type} #{name}(#{arg_list.join ', '})#{scope}
      """#"
    # TODO op
    else
      ### !pragma coverage-skip-block ###
      perr root
      throw new Error "unknown root.constructor.name=#{root.constructor.name}"

@gen = (root, opt = {})->
  
  ctx = new module.Gen_context
  root.top_scope = true
  ret = walk root, ctx
  """
  #include "../lib/index.h"
  
  #{ret}
  """
