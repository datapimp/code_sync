CodeSync.util ||= {}

window.CodeSyncloadedScripts = {}
window.CodeSyncscriptTimers = {}

CodeSync.util.loadStylesheet = (url, options={}, callback)->
  callback ||= options.complete || options.callback

  if typeof(options) is "function" and !callback?
    callback = options
    options = {}

  ss = document.createElement("link")
  ss.type = "text/css"
  ss.rel = "stylesheet"
  ss.href = url
  ss.className = "code-sync-asset"

  if options.tracker
    $("link[data-tracker='#{ options.tracker }']").remove()
    ss.setAttribute("data-tracker", options.tracker )

  document.getElementsByTagName("head")[0].appendChild(ss);

  callback?.call?(@, url, options)

CodeSync.util.loadScript = (url, options={}, callback) ->
  loaded = window.CodeSyncloadedScripts
  timers = window.CodeSyncscriptTimers

  callback ||= options.complete || options.callback

  if typeof(options) is "function" and !callback?
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

CodeSync.util.inspectElementsWithin = (options={})->
  {root,el,fn} = options

  root ||= window

  color = (e)->
    $target = $(e.target)

    $target.css 'background-color': '#9FC4E7', 'opacity': .5

    $target.children().each (i, el)->
      $(el).css 'background-color': '#C2DDB6', 'opacity': .5

  uncolor = (e)->
    $target = $(e.target)
    $target.attr('style', '')
    $target.children().each (i,el)-> $(el).attr('style', '')

  disable = ()->
    root.$('*').off(".inspekt")
    el

  return disable() if options.disable


  clickHandler = _.debounce (e)->
    uncolor(e)
    root.$(el).trigger "inspekt", e, root.$(e.target)
    disable()
  , 150

  elements = root.$(el).find('*')

  elements.off(".inspekt")

  elements.on("mouseover.inspekt", color).on("mouseout.inspekt", uncolor).on "click.inspekt", (e)->
    clickHandler(e)
    elements.off(".inspekt")

  root.$(el)
