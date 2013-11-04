evalRunner = (code, onError) =>
  try
    eval(code)
  catch e
    onError?(e.message)
    throw(e)

CodeSync.detectGlobalChangeTriggers = (type,attributes={})->
  # TODO
  # If we detect changes to important files, respond accordingly.
  # for example, if a variables.css change is detected, we'll need to
  # load the whole shebang
  true

CodeSync.onScriptChange = CodeSync.onTemplateChange = CodeSync.onStyleChange = ()-> true

CodeSync.processChangeNotification = (attributes={}, options={})->
  {type,compiled,content} = attributes

  return if CodeSync.beforeChange?(attributes,options) is false

  type ||= "template" if attributes.template is true

  unless type?
    if attributes.logical_name?.match('.css')
      type = "stylesheet"
    if attributes.logical_name.match('.js')
      type = "script"

  CodeSync.detectGlobalChangeTriggers(type, attributes)

  switch type
    when "stylesheet"
      $("head style[data-codesync-document='#{ options.origin }']").remove()
      $("head").append "<style type='text/css' data-codesync-document='#{ options.origin }'>#{ compiled }</style>"
      hookFn = CodeSync.onStyleChange
    when "template"
      evalRunner(compiled, attributes.error)
      hookFn = CodeSync.onTemplateChange
    when "script"
      evalRunner(compiled, attributes.error)
      hookFn = CodeSync.onScriptChange

  _.delay ()->
    hookFn?(attributes, options)
    attributes.complete?(attributes, options)
    attributes.success?(attributes, options)
  , 150
