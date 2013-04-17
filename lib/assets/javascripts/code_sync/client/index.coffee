#= require_self
#= require ./util

class CodeSync.Client
  constructor: ()->
    CodeSync.util.loadScript "http://localhost:9295/faye/client.js", _.once ()=>

      _.delay ()=>
        @setupSocket()
      , 25

  setupSocket: ()->
    @socket = new Faye.Client("http://localhost:9295/faye")

    @socket.subscribe "/code-sync", (notification)=>
      console.log "notification", notification

      if notification.name?.match(/\.js$/)
        @onJavascriptNotification.call(@,notification)

      if notification.name?.match(/\.css$/)
        @onStylesheetNotification.call(@, notification)

  onJavascriptNotification: (notification)->
    if notification.path
      CodeSync.util.loadScript "http://localhost:9295/assets/#{ notification.path }", ()->
        console.log "Processed JS Notification", notification

  onStylesheetNotification: (notification)->
    if notification.path && notification.name
      CodeSync.util.loadStylesheet "http://localhost:9295/assets/#{ notification.path }", tracker: notification.name, ()->
        console.log "Processed CSS Notification", notification


