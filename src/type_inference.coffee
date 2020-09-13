{Ti_context} = require "./type_inference/common.coffee"

stage1 = require "./type_inference/stage1"
stage2 = require "./type_inference/stage2"

@gen = (root, opt)->
  ctx = new Ti_context
  ctx.walk = stage1.walk
  stage1.walk root, ctx
  
  for i in [0 ... 100] # prevent infinite
    ctx = new Ti_context
    ctx.first_stage_walk = stage1.walk
    ctx.walk = stage2.walk
    stage2.walk root, ctx
    break if ctx.change_count == 0
  
  root