module.exports = (root, ctx)->
  {walk} = ctx
  switch root.constructor.name
    when "Scope"
      for v, idx in root.list
        root.list[idx] = walk v, ctx
      root
    
    # ###################################################################################################
    #    expr
    # ###################################################################################################
    when "Var", "Const"
      root
    
    # TODO OP
    
    when "Fn_call"
      for v,idx in root.arg_list
        root.arg_list[idx] = walk v, ctx
      root.fn = walk root.fn, ctx
      root
    
    when "Fn_decl"
      root.fn = walk root.scope, ctx
      root
    # ###################################################################################################
    
    else
      ### !pragma coverage-skip-block ###
      perr root
      throw new Error "unknown root.constructor.name #{root.constructor.name}"
  