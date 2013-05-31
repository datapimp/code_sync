#= require_self
#= require ./util

class CodeSync.Client

  @_clients: []

  @get: ()->
    CodeSync.Client._clients[0]

  VERSION: CodeSync.VERSION

  logLevel: 0

  enablePush: true

  constructor: (options={})->
    @logLevel = options.logLevel || 0

    CodeSync.Client._clients.push(@)

    if @enablePush is true
      @channel = options.channel || getClientChannel()

      @providerLib = "#{ CodeSync.get("socketEndpoint") }/client.js"

      CodeSync.util.loadScript @providerLib, ()=>
        return if @clientLoaded is true || !@providerAvailable()

        setTimeout ()=>
          try
            @setupSocket()
          catch e
            console.log "Error setting up codesync client: #{ e.message }"
        , 25

        @clientLoaded = true

    @getSprocketsInfo()

  getSprocketsInfo: ()->
    $.ajax
      type: "GET"
      url: CodeSync.get("serverInfoEndpoint")
      success: (response={})=>
        CodeSync.set("latestServerInfo", response)

        if response.root
          CodeSync.set("projectRoot", response.root)

        if response.project_assets? && CodeSync.ProjectAssets?
          @projectAssets = new CodeSync.ProjectAssets(response.project_assets)

  buildStylesheetMap: ()->
    @stylesheetMap = {}

    for styleElement in $('link[rel="stylesheet"]')
      if href = $(styleElement).attr('href')
        @stylesheetMap[href] = styleElement

  buildScriptMap: ()->
    @scriptMap = {}

    for scriptElement in $('script[type="text/javascript"]')
      if src = $(scriptElement).attr('src')
        @scriptMap[src] = scriptElement

    @scriptMap

  providerAvailable: ()->
    Faye?

  subscribeWith: (cb)->
    @socket?.subscribe(@channel, cb)

  setupSocket: ()->
    if @socket = new Faye?.Client(CodeSync.get("socketEndpoint"))
      @subscribeWith ()=>
        @defaultNotificationHandler.apply(@, arguments)

  notificationHandlerOptions: {}

  defaultNotificationHandler: (notification)->
    if doc = @projectAssets?.findDocumentByPath(notification.path)
      if notification.contents
        doc.set("contents", notification.contents, silent: false)
        doc.trigger "contents:synced"

    console.log "Detected Change in #{ window.name }"

    CodeSync.processChangeNotification(notification, @notificationHandlerOptions)

# Allows for hijacking a page which includes the code sync client
# and overriding the notification channel.  this allows for sandboxd
# iframes to still interact with the codesync editor components
# in certain apps
getClientChannel = (channel)->
  query = window.location.search.substring(1)
  vars  = query.split('&')

  for item in vars when item.match(/code_sync_channel/)
    [param,channel] = item.split('=') unless channel?

  if channel then decodeURIComponent("/code-sync/#{ channel }") else "/code-sync/outbound"
