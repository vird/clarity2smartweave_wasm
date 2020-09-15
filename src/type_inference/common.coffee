module = @

# ###################################################################################################
# STUB
config = 
  bytes_type_map : {}
  any_int_type_list: ["int"]
  any_int_type_map :
    int : true
# ###################################################################################################
@bin_op_ret_type_map_list = {
  BOOL_AND: [["bool", "bool", "bool"]]
  BOOL_OR : [["bool", "bool", "bool"]]
  BOOL_XOR: [["bool", "bool", "bool"]]
}

for v in "ADD SUB MUL DIV MOD POW".split  /\s+/g
  @bin_op_ret_type_map_list[v] = []
# ###################################################################################################
#    numeric operation type table
# ###################################################################################################
do ()=>
  for op in "ADD SUB MUL DIV MOD POW".split  /\s+/g
    list = @bin_op_ret_type_map_list[op]
    for type in config.any_int_type_list
      list.push [type, type, type]
  
# ###################################################################################################
class @Ti_context
  parent    : null
  parent_fn : null
  var_map   : {}
  # external params
  # we call ctx.walk so we can sometimes make calls to previous stage, but continue using current walk
  walk : null
  first_stage_walk : null
  change_count : 0
  
  constructor:()->
    @var_map = {} # TODO default_var_map_gen
  
  change_count_inc : ()->
    @change_count++
    @parent?.change_count_inc()
    return
  
  mk_nest : ()->
    ret = new Ti_context
    ret.parent    = @
    ret.parent_fn = @parent_fn
    ret.walk              = @walk
    ret.first_stage_walk  = @first_stage_walk
    ret
  
  check_id : (id)->
    if @var_map.hasOwnProperty id
      return @var_map[id]
    if @parent
      return @parent.check_id id
    throw new Error "can't find decl for id '#{id}'"

@is_number_type = (type)->
  type.main in ["number", "unsigned_number", "signed_number"]

@is_not_defined_type = (type)->
  type.main in ["_", "number", "unsigned_number", "signed_number"]

is_composite_type = (type)->
  type.main in ["array", "tuple", "map", "struct"]

@type_spread_left = (a_type, b_type, ctx)->
  return a_type if b_type.main == "_"
  if a_type.main == "_" and b_type.main != "_"
    a_type = b_type.clone()
    ctx.change_count_inc()
  else if a_type.main == "number"
    if b_type.main in ["unsigned_number", "signed_number"]
      a_type = b_type.clone()
      ctx.change_count_inc()
    else if b_type.main == "number"
      "nothing"
    else
      throw new Error "can't spread '#{b_type}' to '#{a_type}'"
  else if @is_not_defined_type(a_type) and !@is_not_defined_type(b_type)
    if a_type.main in ["unsigned_number", "signed_number"]
      unless config.any_int_type_map[b_type.main]
        throw new Error "can't spread '#{b_type}' to '#{a_type}'"
    else
      throw new Error "unknown is_not_defined_type spread case"
    a_type = b_type.clone()
    ctx.change_count_inc()
  else if !@is_not_defined_type(a_type) and @is_not_defined_type(b_type)
    # will check, but not spread
    if b_type.main in ["number", "unsigned_number", "signed_number"]
      unless config.any_int_type_map[a_type.main]
        throw new Error "can't spread '#{b_type}' to '#{a_type}'. Reverse spread collision detected"
  else
    return a_type if a_type.cmp b_type
    if is_composite_type a_type
      if !is_composite_type b_type
        perr "can't spread between '#{a_type}' '#{b_type}'. Reason: is_composite_type mismatch"
        return a_type
      
      # composite
      if a_type.main != b_type.main
        throw new Error "spread composite collision '#{a_type}' '#{b_type}'. Reason: composite container mismatch"
      
      if a_type.nest_list.length != b_type.nest_list.length
        throw new Error "spread composite collision '#{a_type}' '#{b_type}'. Reason: nest_list length mismatch"
      
      for idx in [0 ... a_type.nest_list.length]
        inner_a = a_type.nest_list[idx]
        inner_b = b_type.nest_list[idx]
        new_inner_a = @type_spread_left inner_a, inner_b, ctx
        a_type.nest_list[idx] = new_inner_a
      
      # TODO struct? but we don't need it? (field_map)
    else
      if is_composite_type b_type
        perr "can't spread between '#{a_type}' '#{b_type}'. Reason: is_composite_type mismatch"
        return a_type
      # scalar
      if @is_number_type(a_type) and @is_number_type(b_type)
        return a_type
      
      throw new Error "spread scalar collision '#{a_type}' '#{b_type}'. Reason: type mismatch"
  
  return a_type
