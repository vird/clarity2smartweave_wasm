#!/usr/bin/env iced
fs = require "fs"
util = require "util"
require "fy"

buf = fs.readFileSync "build/mod/index.wasm"

utf8decoder = new util.TextDecoder "utf-8"
memory = null
wasm2string = (s_pointer)->
  # нельзя делать 1 раз, т.к. memory.buffer может поменяться и будет
  # Cannot perform %TypedArray%.prototype.slice on a neutered ArrayBuffer
  u8  = new Int8Array memory.buffer
  iter = s_pointer
  while u8[iter]
    iter++
  
  if iter != s_pointer
    utf8decoder.decode u8.subarray(s_pointer, iter)
  else
    ""
    
import_object = {
  env: {
    user_throw : (s_pointer)->
      str = wasm2string s_pointer
      throw new Error "wasm user_throw #{str}"
     
    logsi : (s_pointer, i)->
      str = wasm2string s_pointer
      p "#{str} #{i}"
    
    putsi : (s_pointer, i)->
      str = wasm2string s_pointer
      p "#{str} #{i}"
  }
}

await WebAssembly.instantiate(buf, import_object).cb defer(err, instance); throw err if err

{
  memory
  __heap_base
  __heap_set
  __alloc_init
  ws_malloc
  # _main
  LENGTH_OFFSET
} = instance.instance.exports

__heap_set(__heap_base)
__alloc_init()


ret = instance.instance.exports.say_hi()
p wasm2string ret
ret = instance.instance.exports.echo_number()
p ret

# instance.instance.exports.say_hi
# instance.instance.exports.echo_number