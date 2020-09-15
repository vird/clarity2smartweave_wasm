assert = require "assert"

{parse}     = require "../src/parser"
{transform} = require "../src/ast_transform"
translate_c = require "../src/translate_c"

@mk_test = (code, o_text)->
  ret_ast = parse code
  ret_ast = transform(ret_ast, {code})
  ret_c = translate_c.gen ret_ast
  ret_c = ret_c.trim()
  o_text = o_text.trim()
  assert.strictEqual ret_c, o_text
