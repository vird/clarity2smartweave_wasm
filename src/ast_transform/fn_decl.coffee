default_walk = require "./default_walk"
ast = require "../ast"
clarity_type_parse = require "../clarity_type_parse"
Type = require "type"

walk = (root, ctx)->
  switch root.constructor.name
    when "Fn_call"
      if root.name == "define-public"
        ret = new ast.Fn_decl
        if !(root.arg_list[0] instanceof ast.Fn_call)
          ast.pretty_node_error root.arg_list[0], ctx.code, "fn name should be identifier"
        
        # ret_type, arg_type0, arg_type1, arg_typeN
        ret.type = new Type "function<_>"
        ret.name = root.arg_list[0].name
        
        
        for v, idx in root.arg_list[0].arg_list
          if !(v instanceof ast.Fn_call)
            ast.pretty_node_error v, ctx.code, "fn decl argument should be tuple (name type)"
          if v.arg_list.length != 1
            if v.arg_list.length == 0
              ast.pretty_node_error v, ctx.code, "fn decl argument should be tuple (name type). Missing type"
            else
              ast.pretty_node_error v, ctx.code, "fn decl argument should be tuple (name type). Extra stuff"
          
          if !(v instanceof ast.Fn_call)
            ast.pretty_node_error v, ctx.code, "fn decl argument should be tuple (name type). Type is not identifier"
          
          try
            type = clarity_type_parse v.arg_list[0].name
          catch err
            ast.pretty_node_error v, ctx.code, "fn decl argument should be tuple (name type). Bad type. #{err.message}"
          
          ret.type.nest_list[idx+1] = type
          ret.arg_name_list.push v.name
        
        
        for v, idx in root.arg_list
          continue if idx <= 0
          # only top-scope functions can have Fn_decl as define-public
          ret.scope.list.push v
        
        ret.offset_start= root.offset_start
        ret.offset_end  = root.offset_end
        
        return ret
      root
    
    else
      default_walk root, ctx

@transform = (root, ctx)->
  ctx.walk = walk
  walk root, ctx
