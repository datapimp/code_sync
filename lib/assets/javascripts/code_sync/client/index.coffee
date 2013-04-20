#= require_self
#= require ./util

class CodeSync.Client
  VERSION: CodeSync.VERSION

  constructor: ()->
    CodeSync.util.loadScript "http://localhost:9295/faye/client.js", _.once ()=>
      _.delay ()=>
        @setupSocket() if Faye?
      , 25

  setupSocket: ()->
    return unless Faye?

    @socket = new Faye.Client("http://localhost:9295/faye")

    @socket.subscribe "/code-sync", (notification)=>
      console.log "notification", notification

      if notification.name?.match(/\.js$/)
        @onJavascriptNotification.call(@,notification)

      if notification.name?.match(/\.css$/)
        @onStylesheetNotification.call(@, notification)

  javascriptCallbacks: []

  stylesheetCallbacks: []

  afterJavascriptChange: (callback)->
    @javascriptCallbacks.push(callback)

  afterStylesheetChange: (callback)->
    @stylesheetCallbacks.push(callback)

  onJavascriptNotification: (notification)->
    client = @

    if notification.source
      sourceEval.call(window, notification.source)

      for callback in client.javascriptCallbacks when callback.call?
        callback.call(client, notification)

      return

    if notification.path
      CodeSync.util.loadScript "http://localhost:9295/assets/#{ notification.path }", ()->
        for callback in client.javascriptCallbacks when callback.call?
          callback.call(@, notification)

  onStylesheetNotification: (notification)->
    client = @

    if notification.path && notification.name
      CodeSync.util.loadStylesheet "http://localhost:9295/assets/#{ notification.path }", tracker: notification.name, ()->
        for callback in client.stylesheetCallbacks when callback.call?
          callback.call(@, notification)


sourceEval = (source)->
  eval(source)