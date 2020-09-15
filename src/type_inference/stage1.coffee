# bottom-to-top walk + type reference

Type = require "type"
ti = require "./common"

@walk = (root, ctx)->
  switch root.constructor.name
    # ###################################################################################################
    #    expr
    # ###################################################################################################
    when "Var"
      root.type = ti.type_spread_left root.type, ctx.check_id(root.name), ctx
    
    when "Const"
      root.type
    
    when "Bin_op"
      ctx.walk root.a, ctx
      ctx.walk root.b, ctx
      
      switch root.op
        when "ASSIGN"
          root.a.type = ti.type_spread_left root.a.type, root.b.type, ctx
          root.b.type = ti.type_spread_left root.b.type, root.a.type, ctx
          
          root.type = ti.type_spread_left root.type, root.a.type, ctx
          root.a.type = ti.type_spread_left root.a.type, root.type, ctx
          root.b.type = ti.type_spread_left root.b.type, root.type, ctx
        
        when "EQ", "NE", "GT", "GTE", "LT", "LTE"
          root.type   = ti.type_spread_left root.type,   new Type("bool"), ctx
          root.a.type = ti.type_spread_left root.a.type, root.b.type, ctx
          root.b.type = ti.type_spread_left root.b.type, root.a.type, ctx
      
      # bruteforce only at stage 2
      
      root.type
    # ###################################################################################################
    #    stmt
    # ###################################################################################################
    
    when "Scope"
      ctx_nest = ctx.mk_nest()
      for v in root.list
        ctx.walk v, ctx_nest
      
      null
    
    when "Ret"
      if root.t
        root.t.type = ti.type_spread_left root.t.type, ctx.parent_fn.type.nest_list[0], ctx
        ctx.parent_fn.type.nest_list[0] = ti.type_spread_left ctx.parent_fn.type.nest_list[0], root.t.type, ctx
        
        ctx.walk root.t, ctx
      null
    
    when "Fn_decl"
      ctx.var_map[root.name] = root.type
      ctx_nest = ctx.mk_nest()
      ctx_nest.parent_fn = root
      for name,k in root.arg_name_list
        type = root.type.nest_list[k+1]
        ctx_nest.var_map[name] = type
      ctx.walk root.scope, ctx_nest
      root.type
    
    # ###################################################################################################
    #    control flow
    # ###################################################################################################
    
    else
      ### !pragma coverage-skip-block ###
      perr root
      throw new Error "ti phase 1 unknown node '#{root.constructor.name}'"
