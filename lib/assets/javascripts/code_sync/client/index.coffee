#= require_self
#= require ./util

class CodeSync.Client

  @_clients: []

  @get: ()->
    CodeSync.Client._clients[0]

  VERSION: CodeSync.VERSION

  logLevel: 0

  constructor: (options={})->

    @logLevel = options.logLevel || 0

    CodeSync.Client._clients.push(@)

    CodeSync.util.loadScript "#{ CodeSync.get("socketEndpoint") }/client.js", ()=>
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

    @socket = new Faye.Client(CodeSync.get("socketEndpoint"))

    @socket.subscribe "/code-sync/outbound", (notification)=>

      if @logLevel > 0
        console.log "Received notification on outbound channel", notification

      @onNotification?.call?(@, notification)

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

  afterJavascriptChange: (callback, clearExisting=false)->
    @javascriptCallbacks ||= []
    @javascriptCallbacks = [] if clearExisting is true
    @javascriptCallbacks.push(callback)

  afterStylesheetChange: (callback, clearExisting=false)->
    @stylesheetCallbacks ||= []
    @stylesheetCallbacks = [] if clearExisting is true
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
      CodeSync.util.loadScript "#{ CodeSync.get("sprocketsEndpoint") }/#{ notification.path }", ()->
        for callback in client.javascriptCallbacks when callback.call?
          callback.call(@, notification)

  onStylesheetNotification: (notification)->
    client = @

    if notification.path && notification.name
      CodeSync.util.loadStylesheet "#{ CodeSync.get("sprocketsEndpoint") }/#{ notification.path }", tracker: notification.name, ()->
        for callback in client.stylesheetCallbacks when callback.call?
          callback.call(@, notification)


sourceEval = (source)->
  eval(source)