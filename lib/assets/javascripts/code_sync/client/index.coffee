#= require ./dependencies

#= require_self
#= require ./util

root = @

if typeof(exports) isnt "undefined"  
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

CodeSync.VERSION = "0.0.4"

class CodeSync.Client
  constructor: ()->
    
    CodeSync.util.loadScript "http://localhost:9295/faye/client.js", ()=>
      if Faye?
        @socket = new Faye.Client("http://localhost:9295/faye")
        console.log "Subscribing on ", @socket
        @socket.subscribe "/code-sync", ()=>
          console.log "Received Message", arguments

