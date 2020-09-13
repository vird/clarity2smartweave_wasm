assert = require "assert"

{parse} = require "../src/parser"

describe "parser section", ()->
  it '(print "HelloWorld!")', ()->
    str = """
      (print "HelloWorld!")
    """
    parse str
  