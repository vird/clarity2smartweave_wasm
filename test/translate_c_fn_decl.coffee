{mk_test} = require "./util"

describe "translate_c section", ()->
  describe "fn_decl", ()->
    it "no arg, ret str", ()->
      i_text = """
        (define-public (sample)
          (ok "hello world")
        )
      """
      o_text = """
        #include "../lib/index.h"
        
        __attribute__((visibility("default")))
        char* sample(){
          return ("hello world");
        };
      """#"
      mk_test i_text, o_text
    
    it "no arg, ret int", ()->
      i_text = """
        (define-public (sample)
          (ok 1)
        )
      """
      o_text = """
        #include "../lib/index.h"
        
        __attribute__((visibility("default")))
        i32 sample(){
          return (1);
        };
      """#"
      mk_test i_text, o_text
  