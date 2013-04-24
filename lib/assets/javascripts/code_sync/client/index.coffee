#= require_self
#= require ./util

class CodeSync.Client
  VERSION: CodeSync.VERSION

  constructor: ()->
    CodeSync.util.loadScript "http://localhost:9295/faye/client.js", ()=>
      return if @clientLoaded is true

      setTimeout ()=>
        try
          @setupSocket()
        catch e
          console.log "Error setting up codesync client"
      , 25

      @clientLoaded = true

  setupSocket: ()->
    return unless Faye?

    @socket = new Faye.Client("http://localhost:9295/faye")

    @socket.subscribe "/code-sync", (notification)=>
      if notification.name?.match(/\.js$/)
        @onJavascriptNotification.call(@,notification)

      if notification.name?.match(/\.css$/)
        @onStylesheetNotification.call(@, notification)

  javascriptCallbacks: []

  stylesheetCallbacks: []

  removeJavascriptCallbacks: ()->
    @javascriptCallbacks = []

  removeStylesheetCallbacks: ()->
    @stylesheetCalbacks = []

  afterJavascriptChange: (callback)->
    @javascriptCallbacks.push(callback)

  afterStylesheetChange: (callback)->
    @stylesheetCallbacks.push(callback)

  onJavascriptNotification: (notification)->
    client = @

    CodeSync.processing = true

    if notification.source
      sourceEval.call(window, notification.source)

      for callback in client.javascriptCallbacks when callback.call?
        callback.call(client, notification)

      CodeSync.processing = false

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