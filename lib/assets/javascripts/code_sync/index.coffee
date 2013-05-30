#= require ./vendor/keylauncher
#= require ./config
#= require_self
#= require ./client
#= require_tree ./lib
#= require_tree ./datasources
#= require ./editor

evalRunner = (code, onError) =>
  try
    eval(code)
  catch e
    onError?(e.message)
    throw(e)

CodeSync.template = (templateIdentifier, variables={})->
  if tmpl = JST[templateIdentifier]
    return tmpl(variables)

  regex = new RegExp("#{ templateIdentifier }$")

  for templateName, templateFunction of JST when templateName.match(regex)
    return templateFunction(variables)

#CodeSync.template.namespaces = ["JST"]

CodeSync.processChangeNotification = (attributes={}, options={})->
  {type,compiled,content} = attributes

  if _(options.skip).indexOf(type) >= 0
    return

  return if CodeSync.beforeChange?(attributes,options) is false

  type ||= "template" if attributes.template is true

  unless type?
    if attributes.logical_name?.match('.css')
      type = "stylesheet"
    if attributes.logical_name.match('.js')
      type = "script"

  switch type
    when "stylesheet"
      $('head style[data-codesync-document]').remove()
      $('head').append "<style type='text/css' data-codesync-document=true>#{ compiled }</style>"
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