op_repack               = require "./ast_transform/op_repack"
fn_decl                 = require "./ast_transform/fn_decl"
# fn_decl_ret_type_detect = require "./ast_transform/fn_decl_ret_type_detect"
ret                     = require "./ast_transform/ret"
type_inference          = require "./type_inference"

@transform = (ast, ctx)->
  ast = op_repack .transform ast, ctx
  ast = fn_decl   .transform ast, ctx
  ast = ret       .transform ast, ctx
  
  ast = type_inference.gen ast
  
  # ast = fn_decl_ret_type_detect .transform ast, ctx
  
  ast
