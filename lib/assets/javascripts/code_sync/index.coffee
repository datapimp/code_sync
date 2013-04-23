#= require_self
#= require code_sync/client

root = @

if typeof(exports) isnt "undefined"
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

CodeSync.VERSION    = "0.2.2"

CodeSync.backends   = {}

CodeSync.util       = {}

CodeSync.set = (setting, value)->
  CodeSync._config[setting] = value

CodeSync.get = (setting)->
  CodeSync._config[setting]
