#= require ../vendor/keylauncher
#= require ./config
#= require_self
#= require ./client
#= require ./editor

CodeSync.processChangeNotification = (attributes={})->
  {type,content} = attributes

  switch type
    when "stylesheet"
      $('head style[data-codesync-document]').remove()
      $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

      hookFn = CodeSync.onStyleChange

    when "template"
      hookFn = CodeSync.onTemplateChange

    when "script"
      evalRunner = (code)->
        try
          eval(code)
        catch e
          attributes.error?(e.message)
          throw(e)

      evalRunner.call(window, content)
      hookFn = CodeSync.onScriptChange


  _.delay ()->
    hookFn?()
    attributes.complete?()
    attributes.success?()
  , 150