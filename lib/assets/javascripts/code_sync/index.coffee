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

  if _(options.skip).indexOf(type) >= 0
    return

  return if CodeSync.beforeChange?(attributes,options) is false

  switch type
    when "stylesheet"
      $('head style[data-codesync-document]').remove()
      $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

      hookFn = CodeSync.onStyleChange

    when "template"
      evalRunner(content, attributes.error)

      hookFn = CodeSync.onTemplateChange
    when "script"
      evalRunner(content, attributes.error)

      hookFn = CodeSync.onScriptChange

  _.delay ()->
    hookFn?()
    attributes.complete?()
    attributes.success?()
  , 150