default_walk = require "./default_walk"
ast = require "../ast"
clarity_type_parse = require "../clarity_type_parse"
Type = require "type"

bin_op_map =
  "+"   : "ADD"
  "-"   : "SUB"
  "*"   : "MUL"
  "/"   : "DIV"
  "mod" : "MOD"
  # "**"  : "POW"
  # ">>"  : "SHR"
  # "<<"  : "SHL"
  
  "and" : "BOOL_AND"
  "or"  : "BOOL_OR"
  "xor" : "BOOL_XOR"
  
  "==" : "EQ"
  "!=" : "NE"
  ">"  : "GT"
  "<"  : "LT"
  ">=" : "GTE"
  "<=" : "LTE"

op_handle = (list, op, ctx)->
  list = list.clone()
  ret = new ast.Bin_op
  ret.op = op
  ret.a = default_walk list.shift(), ctx
  ret.b = default_walk list.shift(), ctx
  ret.type = new Type "_"
  
  while list.length
    old_ret = ret
    ret = new ast.Bin_op
    ret.op= op
    ret.a = old_ret
    ret.b = default_walk list.shift(), ctx
    ret.type = new Type "_"
  return ret

walk = (root, ctx)->
  switch root.constructor.name
    when "Fn_call"
      if bin_op_map[root.fn?.name]?
        # COPYPASTE compatibility mode
        root.op = root.fn?.name
        root.t_list = root.arg_list
        
        if root.arg_list.length == 1
          return default_walk root.arg_list[0], ctx
        return op_handle root.arg_list, bin_op_map[root.fn?.name], ctx
      default_walk root, ctx
    
    when "Op"
      switch root.op
        when "-"
          if root.t_list.length == 0
            throw new Error "don't know how to translate op='#{root.op}' for argument count #{root.t_list.length}"
          if root.t_list.length == 1
            # special case
            ret = new ast.Un_op
            ret.op= root.op
            ret.a = default_walk root.t_list[0], ctx
            ret.type = new Type "_"
            return ret
        
        when "+", "*", "/"
          if root.t_list.length == 0
            throw new Error "don't know how to translate op='#{root.op}' for argument count #{root.t_list.length}"
          if root.t_list.length == 1
            return default_walk root.t_list[0], ctx
        
        else
          throw new Error "unknown op '#{root.op}'"
      
      op_handle root.t_list, bin_op_map[root.op], ctx
    else
      default_walk root, ctx

@transform = (root, ctx)->
  ctx.walk = walk
  walk root, ctx
