CodeSync.util ||= {}

loadedScripts = {}
scriptTimers = {}

CodeSync.util.loadStylesheet = (url, options={}, callback)->
  ss = document.createElement("link")
  ss.type = "text/css"
  ss.rel = "stylesheet"
  ss.href = url
  ss.className = "code-sync-asset"

  if options.tracker
    $("link[data-tracker='#{ options.tracker }']").remove()
    ss.setAttribute("data-tracker", options.tracker )

  document.getElementsByTagName("head")[0].appendChild(ss);

  callback?.call?(@)

CodeSync.util.loadScript = (url, options={}, callback) ->
  loaded = loadedScripts
  timers = scriptTimers

  if _.isFunction(options) and !callback?
    callback = options
    options = {}

  head= document.getElementsByTagName('head')[0];
  script = document.createElement("script")
  script.src = url
  script.type = "text/javascript"

  that = @
  onLoad = ()->
    if typeof(callback) is "function"
      callback.call(that, url, options, script)

    try
      head.removeChild(script)
    catch e
      true

    loaded[url] = true

  if options.once is true && loaded[url]
    return false

  head.appendChild(script)

  script.onreadystatechange = ()->
    if script.readyState is "loaded" or script.readyState is "complete"
      onLoad()

  script.onload = onLoad

  if navigator?.userAgent.match(/WebKit/)
    timers[url] = setInterval ()->
      onLoad()
      clearInterval(timers[url])
    , 10
