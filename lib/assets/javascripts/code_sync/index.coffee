#= require_self
#= require code_sync/client

root = @

if typeof(exports) isnt "undefined"
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

CodeSync.VERSION = "0.2.1"

