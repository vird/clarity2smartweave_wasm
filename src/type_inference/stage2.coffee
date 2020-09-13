# Type = require "type"
# ti = require "./common"
 
@walk = (root, ctx)->
  switch root.constructor.name
    # just do the same as first stage for following nodes
    when  "Var",\
          "Const",\
          "Fn_decl",\
          "Scope",\
          "Ret"
      ctx.first_stage_walk root, ctx
    
    # TODO Bin_op, Un_op
    
    else
      ### !pragma coverage-skip-block ###
      perr root
      throw new Error "ti phase 2 unknown node '#{root.constructor.name}'"
