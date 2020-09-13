Type = require "type"
module.exports = (str)->
  switch str
    when "int"
      new Type str
    
    else
      throw new Error "unknown clarity type '#{str}'"
