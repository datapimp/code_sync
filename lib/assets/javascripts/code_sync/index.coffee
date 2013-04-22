#= require_self
#= require code_sync/client

root = @

if typeof(exports) isnt "undefined"
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

_.extend CodeSync,

  VERSION: "0.2.2"

  backends: {}

  util: {}

  _config: {}

  set: (setting, value)->
    CodeSync._config[setting] = value

  get: (setting)->
    CodeSync._config[setting]
