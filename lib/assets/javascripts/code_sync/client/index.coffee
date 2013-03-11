#= require ./dependencies

#= require_self
#= require ./util

root = @

if typeof(CodeSync) isnt "undefined"  
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

CodeSync.VERSION = "0.0.1"