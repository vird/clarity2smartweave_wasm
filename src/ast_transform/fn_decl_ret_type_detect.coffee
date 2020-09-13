# DEPRECATED
default_walk = require "./default_walk"
ast = require "../ast"
clarity_type_parse = require "../clarity_type_parse"
Type = require "type"

walk = (root, ctx)->
  switch root.constructor.name
    when "Ret"
      if !ctx.fn_decl
        throw new Error "return outside Fn_decl"
      
      cur_ret_type = ctx.fn_decl.type.nest_list[0]
      if !root.t
        switch cur_ret_type.main
          when "_"
            ctx.fn_decl.type.nest_list[0] = new Type "void"
          when "void"
            "skip"
          else
            perr root
            throw new Error "return value conflict. Try to replace '#{cur_ret_type}' to void"
      else
        if !root.t.type or root.t.type.main == "_"
          perr root
          throw new Error "no type inference for return value"
        switch cur_ret_type.main
          when "_"
            ctx.fn_decl.type.nest_list[0] = root.t.type
          else
            if !cur_ret_type.cmp root.t.type
              throw new Error "return value conflict. Try to replace '#{cur_ret_type}' to '#{root.t.type}'"
      
      root
    
    when "Fn_decl"
      ctx_nest = clone ctx
      ctx_nest.fn_decl = root
      walk root.scope, ctx_nest
      root
    
    else
      default_walk root, ctx

@transform = (root, ctx)->
  walk root, {
    walk
    fn_decl: null
  }
