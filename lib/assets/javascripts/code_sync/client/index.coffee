#= require_self
#= require ./util

class CodeSync.Client
  constructor: ()->
    CodeSync.util.loadScript "http://localhost:9295/faye/client.js", ()=>
      @setupSocket() if Faye?

  setupSocket: ()->
    @socket = new Faye.Client("http://localhost:9295/faye")

    @socket.subscribe "/code-sync", (notification)=>
      if notification.name?.match(/\.js$/)
        @onJavascriptNotification.call(@,notification)
      if notification.name?.match(/\.css$/)
        @onStylesheetNotification.call(@, notification)

  onJavascriptNotification: (notification)->
    console.log "Received Notification of Javascript Change", notification

  onStylesheetNotification: (notification)->
    console.log "Received Notification Of Stylesheet Change", notification


