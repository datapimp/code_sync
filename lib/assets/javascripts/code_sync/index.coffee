#= require ../vendor/keylauncher
#= require ./config
#= require_self
#= require ./client

#= require ./slide_drawer
#= require ./editor

evalRunner = (code, onError) =>
  try
    eval(code)
  catch e
    onError?(e.message)
    throw(e)

CodeSync.processChangeNotification = (attributes={}, options={})->
  {type,content} = attributes

  console.log "Process Change Notification", attributes, _(options.skip).indexOf(type) >= 0, options

  if _(options.skip).indexOf(type) >= 0
    return

  switch type
    when "stylesheet"
      $('head style[data-codesync-document]').remove()
      $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

      hookFn = CodeSync.onStyleChange

    when "template"
      hookFn = CodeSync.onTemplateChange
      evalRunner(content, attributes.error)
    when "script"
      evalRunner(content, attributes.error)
      hookFn = CodeSync.onScriptChange

  _.delay ()->
    hookFn?()
    attributes.complete?()
    attributes.success?()
  , 150