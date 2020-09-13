assert = require "assert"
fs = require "fs"

{parse} = require "../src/parser"
{transform} = require "../src/ast_transform"

run = (str)->
  # NOTE parse only, todo translation later
  parse str

describe "real contracts section", ()->
  list = fs.readdirSync path = "#{__dirname}/real_contracts"
  for v in list
    cont = fs.readFileSync "#{path}/#{v}", "utf-8"
    do (v, cont)->
      it v, ()->
        run cont
  #
