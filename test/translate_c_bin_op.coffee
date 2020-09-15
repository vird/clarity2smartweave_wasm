{mk_test} = require "./util"

describe "translate_c section", ()->
  describe "bin_op", ()->
    for op in "+-*/"
      do (op)->
        it op, ()->
          i_text = """
            (define-public (sample (a int) (b int))
              (ok (#{op} a b))
            )
          """
          o_text = """
            #include "../lib/index.h"
            
            __attribute__((visibility("default")))
            i32 sample(i32 a, i32 b){
              return ((a #{op} b));
            };
          """#"
          mk_test i_text, o_text
  