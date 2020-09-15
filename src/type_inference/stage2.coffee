Type = require "type"
ti = require "./common"
 
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
    when "Bin_op"
      ctx.walk root.a, ctx
      ctx.walk root.b, ctx
      
      switch root.op
        when "ASSIGN"
          root.a.type = ti.type_spread_left root.a.type, root.b.type, ctx
          root.b.type = ti.type_spread_left root.b.type, root.a.type, ctx
          
          root.type   = ti.type_spread_left root.type,   root.a.type, ctx
          root.a.type = ti.type_spread_left root.a.type, root.type, ctx
          root.b.type = ti.type_spread_left root.b.type, root.type, ctx
          return root.type
        
        when "EQ", "NE", "GT", "GTE", "LT", "LTE"
          root.type   = ti.type_spread_left root.type,  new Type("bool"), ctx
          root.a.type = ti.type_spread_left root.a.type, root.b.type, ctx
          root.b.type = ti.type_spread_left root.b.type, root.a.type, ctx
          return root.type
        
      
      bruteforce_a  = ti.is_not_defined_type root.a.type
      bruteforce_b  = ti.is_not_defined_type root.b.type
      bruteforce_ret= ti.is_not_defined_type root.type
      
      a   = root.a.type .toString()
      b   = root.b.type .toString()
      ret = root.type   .toString()
      
      if !list = ti.bin_op_ret_type_map_list[root.op]
        throw new Error "unknown bin_op #{root.op}"
        
      # filter for fully defined types
      found_list = []
      for tuple in list
        continue if tuple[0] != a   and !bruteforce_a
        continue if tuple[1] != b   and !bruteforce_b
        continue if tuple[2] != ret and !bruteforce_ret
        found_list.push tuple
      
      # filter for partially defined types
      if ti.is_number_type root.a.type
        filter_found_list = []
        for tuple in found_list
          continue if !config.any_int_type_map.hasOwnProperty tuple[0]
          filter_found_list.push tuple
        
        found_list = filter_found_list
      
      if ti.is_number_type root.b.type
        filter_found_list = []
        for tuple in found_list
          continue if !config.any_int_type_map.hasOwnProperty tuple[1]
          filter_found_list.push tuple
        
        found_list = filter_found_list
      
      if ti.is_number_type root.type
        filter_found_list = []
        for tuple in found_list
          continue if !config.any_int_type_map.hasOwnProperty tuple[2]
          filter_found_list.push tuple
        
        found_list = filter_found_list
      
      # ###################################################################################################
      if found_list.length == 0
        throw new Error "type inference stuck bin_op #{root.op} invalid a=#{a} b=#{b} ret=#{ret}"
      else if found_list.length == 1
        [a, b, ret] = found_list[0]
        root.a.type = ti.type_spread_left root.a.type, new Type(a), ctx
        root.b.type = ti.type_spread_left root.b.type, new Type(b), ctx
        root.type   = ti.type_spread_left root.type,   new Type(ret), ctx
      else
        if bruteforce_a
          a_type_list = []
          for tuple in found_list
            a_type_list.upush tuple[0]
          if a_type_list.length == 0
            perr "bruteforce stuck bin_op #{root.op} caused a can't be any type"
          else if a_type_list.length == 1
            root.a.type = ti.type_spread_left root.a.type, new Type(a_type_list[0]), ctx
          else
            if new_type = get_list_sign a_type_list
              root.a.type = ti.type_spread_left root.a.type, new Type(new_type), ctx
        
        if bruteforce_b
          b_type_list = []
          for tuple in found_list
            b_type_list.upush tuple[1]
          if b_type_list.length == 0
            perr "bruteforce stuck bin_op #{root.op} caused b can't be any type"
          else if b_type_list.length == 1
            root.b.type = ti.type_spread_left root.b.type, new Type(b_type_list[0]), ctx
          else
            if new_type = get_list_sign b_type_list
              root.b.type = ti.type_spread_left root.b.type, new Type(new_type), ctx
        
        if bruteforce_ret
          ret_type_list = []
          for tuple in found_list
            ret_type_list.upush tuple[2]
          if ret_type_list.length == 0
            perr "bruteforce stuck bin_op #{root.op} caused ret can't be any type"
          else if ret_type_list.length == 1
            root.type = ti.type_spread_left root.type, new Type(ret_type_list[0]), ctx
          else
            if new_type = get_list_sign ret_type_list
              root.type = ti.type_spread_left root.type, new Type(new_type), ctx
      
      root.type
    
    else
      ### !pragma coverage-skip-block ###
      perr root
      throw new Error "ti phase 2 unknown node '#{root.constructor.name}'"
