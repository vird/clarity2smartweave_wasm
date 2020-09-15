assert = require "assert"

{parse} = require "../src/parser"

describe "parser section", ()->
  it '(print "HelloWorld!")', ()->
    str = """
      (print "HelloWorld!")
    """
    parse str
  
  describe "throws (pretty errors)", ()->
    it '(print "HelloWorld!"', ()->
      try
        parse """
          (print "HelloWorld!"
        """
      catch err
        assert.strictEqual err.message, """
          PARSE ERROR. Expected close_bracket
          
          code:
           1:(print "HelloWorld!"
                                 ^
          """
    it '("HelloWorld!")', ()->
      try
        parse """
          ("HelloWorld!")
        """
      catch err
        assert.strictEqual err.message, """
          PARSE ERROR. Expected identifier
          
          code:
           1:("HelloWorld!")
              ^
          """