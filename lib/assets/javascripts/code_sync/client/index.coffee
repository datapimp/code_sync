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

    @channel = options.channel || getClientChannel()

    CodeSync.util.loadScript "#{ CodeSync.get("socketEndpoint") }/client.js", ()=>
      return if @clientLoaded is true

      setTimeout ()=>
        try
          @setupSocket()
        catch e
          console.log "Error setting up codesync client: #{ e.message }"
      , 25

      @clientLoaded = true

  subscribeWith: (cb)->
    @socket?.subscribe @channel, cb

  setupSocket: ()->
    return unless Faye?

    @socket = new Faye.Client(CodeSync.get("socketEndpoint"))

    @subscribeWith(CodeSync.processChangeNotification)

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
