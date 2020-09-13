#!/usr/bin/env iced
fs = require "fs"
require "fy"
# not work, because "export"
# fix with this.handle = async function(state, action) {
compiled = require "./build/compiled"

state = {}
action = {
  input:
    function: "echo-number"
    val : 1
}
await compiled.handle(state, action).cb defer(err, res); throw err if err
p res
