CodeSync.Document = Backbone.Model.extend

  defaults: ()->
    name: "codesync_document"
    mode: @determineMode()
    extension: @determineExtension()

  toJSON: ()->
    name: @get('name')
    extension: @get('extension')
    path: @get('path')
    contents: @get('contents')

  isNew: ()->
    true

  loadInPage: ->
    if @type() is "stylesheet"
      helpers.processStyleContent.call(@, @get('compiled'))
    else if @type() is "script"
      helpers.processScriptContent.call(@, @get('compiled'))

  type: ()->
    switch @get("mode")
      when "css","sass","scss","less"
        "stylesheet"

      when "coffeescript","javascript","skim","mustache","jst","haml","eco"
        "script"

  determineMode: ->
    path = @get("path") || @get("name")

    unless path?
      return CodeSync.get("defaultFileType")

    mode = if path.match(/\.coffee/)
      "coffeescript"
    else if path.match(/\.js$/)
      "javascript"
    else if path.match(/\.md$/)
      "markdown"
    else if path.match(/\.css$/)
      "css"
    else if path.match(/\.rb$/)
      "ruby"
    else if path.match(/\.html$/)
      "htmlmixed"
    else if path.match(/\.less/)
      "less"
    else if path.match(/\.skim/)
      "skim"
    else if path.match(/\.haml/)
      "haml"
    else if path.match(/\.sass/)
      "sass"
    else if path.match(/\.scss/)
      "css"


helpers =
  processStyleContent: (content)->
    $('head style[data-codesync-document]').remove()
    $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

  processScriptContent: (code)->
    evalRunner = (code)-> eval(code)
    evalRunner.call(window, code)
