root = @

if typeof(exports) isnt "undefined"
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

CodeSync.VERSION    = "0.5.2"

CodeSync.backends   = {}

CodeSync.util       = {}
CodeSync.plugins    = {}

CodeSync._config ||=
  defaultFileType: "coffeescript"
  assetCompilationEndpoint: "http://localhost:9295/source"
  serverInfoEndpoint: "http://localhost:9295/info"
  sprocketsEndpoint: "http://localhost:9295/assets"
  socketEndpoint: "http://localhost:9295/faye"

CodeSync.set = (setting, value)->
  CodeSync._config[setting] = value

CodeSync.get = (setting)->
  CodeSync._config[setting]
