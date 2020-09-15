module = @
require "fy"
ast = require "./ast"
Type = require "type"

string_regex_craft = ///
    \\[^xu] |               # x and u are case sensitive while hex letters are not
    \\x[0-9a-fA-F]{2} |     # Hexadecimal escape sequence
    \\u(?:
      [0-9a-fA-F]{4} |      # Unicode escape sequence
      \{(?:
        [0-9a-fA-F]{1,5} |  # Unicode code point escapes from 0 to FFFFF
        10[0-9a-fA-F]{4}    # Unicode code point escapes from 100000 to 10FFFF
      )\}
    )
///.toString().replace(/\//g,'')
double_quoted_regex_craft = ///
  (?:
    [^\\] |
    #{string_regex_craft}
  )*?
///.toString().replace(/\//g,'')
dq_regex = new RegExp "^\"#{double_quoted_regex_craft}\""

class @Parser_context
  base_str: ""
  str     : ""
  # allow_throw_on_failure : false
  
  _start_offset_list : []
  constructor : ()->
    @_start_offset_list = []
  
  # ###################################################################################################
  #    L0
  # ###################################################################################################
  regex : (reg_exp, name, optional = false)->
    if reg_ret = reg_exp.exec @str
      @str = @str.substr reg_ret[0].length
      return reg_ret
    if @allow_throw_on_failure and !optional
      @pos_error "PARSE ERROR. Expected #{name}"
    null
  
  space : ()->
    @regex /^[\s\n]+/i, "space"
  
  space_opt : ()->
    @regex /^[\s\n]+/i, "space", true
  
  bra_op : ()->
    @regex /^\([\s\n]*/, "open_bracket"
  
  bra_cl : ()->
    @regex /^\)[\s\n]*/, "close_bracket"
  
  op : ()->
    @regex /^[-+*\/]/i, "op"
  # ###################################################################################################
  #    L1 (returns AST)
  # ###################################################################################################
  ast_pos_wrap : (cb)->
    backup_str = @str
    @_start_offset_list.push @base_str.length - @str.length
    if ast_node = cb()
      end_offset = @base_str.length - @str.length
      # NOTE not-clonable part
      ast_node.offset_start = @_start_offset_list.pop()
      ast_node.offset_end   = end_offset
      return ast_node
    
    @str = backup_str
    @_start_offset_list.pop()
    return
  
  fail_wrap : (cb)->
    old_val = @allow_throw_on_failure
    @allow_throw_on_failure = true
    ast_node = cb()
    @allow_throw_on_failure = old_val
    ast_node
  
  identifier : ()->
    @ast_pos_wrap ()=>
      # if reg_ret = @regex /^[_a-z][_a-z0-9]*/i, "identifier"
      if reg_ret = @regex /^[_a-z][-_a-z0-9]*/i, "identifier"
        ret = new ast.Var
        ret.name = reg_ret[0]
        ret.type = new Type "_"
        return ret
      null
  
  string : ()->
    @ast_pos_wrap ()=>
      if reg_ret = @regex dq_regex, "string"
        ret = new ast.Const
        ret.type = new Type "string"
        # DANGER
        ret.val = JSON.parse reg_ret[0]
        return ret
      null
  
  integer : ()->
    @ast_pos_wrap ()=>
      if reg_ret = @regex /^-?\d+/, "integer"
        ret = new ast.Const
        if reg_ret[0] == "-"
          # ret.type = new Type "number"
          ret.type = new Type "uint"
        else
          # ret.type = new Type "signed_number"
          ret.type = new Type "int"
        # DANGER
        ret.val = JSON.parse reg_ret[0]
        return ret
      null
  
  # ###################################################################################################
  #    L2 (sometimes can call L3 for expr, scope)
  # ###################################################################################################
  bra_fn_call : ()->
    @ast_pos_wrap ()=>
      
      return null if !@bra_op()
      
      if ret_opt = @op()
        op_name = ret_opt[0]
      else
        fn_name_var_ast = @fail_wrap ()=>@identifier()
      @space()
      
      arg_list = []
      
      loop
        break if !expr = @expr()
        arg_list.push expr
      
      @fail_wrap ()=>@bra_cl()
      
      if fn_name_var_ast?
        ret = new ast.Fn_call
        ret.fn = fn_name_var_ast
        ret.arg_list = arg_list
      else
        ret = new ast.Op
        ret.op = op_name
        ret.t_list = arg_list
      ret
  
  # ###################################################################################################
  #    L3
  # ###################################################################################################
  expr : ()->
    @ast_pos_wrap ()=>
      @space_opt()
      
      if ret = @bra_fn_call()
        @space_opt()
        return ret
      
      if ret = @identifier()
        @space_opt()
        return ret
      
      if ret = @string()
        @space_opt()
        return ret
      
      if ret = @integer()
        @space_opt()
        return ret
      
      null
  
  scope : ()->
    @ast_pos_wrap ()=>
      list = []
      loop
        break if !loc_ret = @expr()
        list.push loc_ret
      
      @space_opt()
      
      ret = new ast.Scope
      ret.list = list
      ret
  
  # ###################################################################################################
  #    TOP
  # ###################################################################################################
  walk : ()->
    # last possible call will fail
    # @allow_throw_on_failure = true
    
    return ret if ret = @scope()
    @pos_error "Can't parse"
  
  pos_error : (msg)->
    offset = @base_str.length - @str.length
    passed_str = @base_str.substr 0, offset
    
    # prev
    passed_line_list = passed_str.split("\n")
    passed_last_str = passed_line_list.pop()
    line_offset = passed_last_str.length+1
    
    # next
    next_line_list = @str.split("\n")
    next_line_list.length = Math.min next_line_list.length, 3
    
    next_line_list[0] = passed_last_str+next_line_list[0]
    
    cursor = "^".rjust line_offset
    next_line_list.insert_after 0, cursor
    if last2 = passed_line_list.pop()
      next_line_list.unshift last2
    
    # set line numbers:
    line_number = passed_line_list.length+1
    pad = line_number.toString().length+1
    for v,idx in next_line_list
      if /^\s*\^\s*$/.test v
        next_line_list[idx] = "#{' '.rjust pad} #{v}"
      else
        next_line_list[idx] = "#{(line_number++).rjust pad}:#{v}"
    code = next_line_list.join '\n'
    
    
    throw new Error """
      #{msg}
      
      code:
      #{code}
      """
  
  clone : ()->
    ret = new module.Parser_context
    ret.base_str= @base_str
    ret.str     = @str
    # ret.allow_throw_on_failure = @allow_throw_on_failure
    ret

@parse = (str)->
  ctx = new module.Parser_context
  ctx.base_str= str
  ctx.str     = str
  ret = ctx.walk()
  if ctx.str.length
    ctx.pos_error "unparsed chunk of code"
  
  ret