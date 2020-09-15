module = @
require "fy"
obj_set module, require "ast4gen"

# TODO project-specific AST


@pretty_node_error = (node, code, msg)->
  
  perr node
  throw new Error msg

class @Op
  op      : null
  t_list  : []
  
  constructor:()->
    @t_list = []
  
