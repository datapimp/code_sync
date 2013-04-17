#= require_self
#= require ./util

class CodeSync.Client
  constructor: ()->
    console.log "Creating the codesync client"
    CodeSync.util.loadScript "http://localhost:9295/faye/client.js", _.once ()=>

      _.delay ()=>
        @setupSocket()
      , 25

  setupSocket: ()->
    @socket = new Faye.Client("http://localhost:9295/faye")

    console.log "Subscribing to code-sync channel", @socket

    @socket.subscribe "/code-sync", (notification)=>
      console.log "Received Notification", notification

      if notification.name?.match(/\.js$/)
        @onJavascriptNotification.call(@,notification)

      if notification.name?.match(/\.css$/)
        @onStylesheetNotification.call(@, notification)

  onJavascriptNotification: (notification)->
    console.log "Received Notification of Javascript Change", notification

  onStylesheetNotification: (notification)->
    console.log "Received Notification Of Stylesheet Change", notification


