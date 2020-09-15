default_walk = require "./default_walk"
ast = require "../ast"
clarity_type_parse = require "../clarity_type_parse"
Type = require "type"

walk = (root, ctx)->
  switch root.constructor.name
    when "Fn_call"
      if root.fn?.name == "ok"
        ret = new ast.Ret
        if root.arg_list.length == 0
          "skip"
        else if root.arg_list.length == 1
          ret.t = root.arg_list[0]
        else
          ast.pretty_node_error root, ctx.code, "return can't have multiple values, use tuple to wrap them"
        
        ret.offset_start= root.offset_start
        ret.offset_end  = root.offset_end
        
        return ret
      root
    
    else
      default_walk root, ctx

@transform = (root, ctx)->
  ctx.walk = walk
  walk root, ctx
