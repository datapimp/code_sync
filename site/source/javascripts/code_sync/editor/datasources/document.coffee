CodeSync.Document = Backbone.Model.extend
  initialize: (@attributes,options)->
    Backbone.Model::initialize.apply(@, arguments)

    @on "change:contents", @process, @

    @on "change:mode", ()=>
      @set('extension', @determineExtension(), silent: true)
      @process()


  url: ()->
    CodeSync.get("assetCompilationEndpoint")

  # Meh this isn't working so great
  defaults: ()->
    name: "untitled"
    mode: @determineMode() || CodeSync.get("defaultFileType")
    extension: @determineExtension()
    compiled: ""
    display: "Untitled"
    contents: "//"

  toJSON: ()->
    name: @get('name')
    path: @get('path')
    extension: @get('extension')
    contents: @get('contents')

  toCodeMirrorDocument: ()->
    CodeMirror.Doc "#{ @get("contents") || '' }", @get("mode"), 0

  process: ()->
    $.ajax
      type: "POST"
      url: CodeSync.get("assetCompilationEndpoint")
      data: JSON.stringify(@toJSON())
      success: (response)=>
        if response.success is true and response.compiled?
          @set("compiled", response.compiled)
          @trigger "status", type: "success", message: "Success"

        if response.success is false and response.error?
          @set("error", response.error?.message)
          @trigger "status", type: "error", message: response.error?.message

  loadInPage: ->
    if @type() is "stylesheet"
      helpers.processStyleContent.call(@, @get('compiled'))
    else if @type() is "script"
      helpers.processScriptContent.call(@, @get('compiled'))

  # Determines how we will handle the compiled assets when loading in the page
  type: ()->
    switch @get("mode")
      when "css","sass","scss","less"
        "stylesheet"
      when "coffeescript","javascript","skim","mustache","jst","haml","eco"
        "script"

  missingFileName: ()->
    name = (@get('path') || @get('name'))
    !name? || name.length is 0

  # If this is an adHoc document that is not being saved to disk, or rather
  # pulled from an existing asset on disk, then we will need to create an extension
  # that is appropriate for the CodeMirror mode, for the purposes of on the fly compilation
  determineExtension: ()->
    filename = @get("name")
    filename ||= if path = @get("path")
      path.split('/').pop()

    if filename?.length > 0
      [filename,parts...] = filename.split('.')
      if parts.length > 0
        return parts.join('.')

    if @get("mode")?
      return CodeSync.Modes.guessExtensionFor( @get('mode') || CodeSync.get("defaultFileType")  )

  # Determine a CodeMirror mode setting appropriate for the file extension
  determineMode: ->
    path = @get("path") || @get("name") || @get("extension")
    CodeSync.Modes.guessModeFor(path)

CodeSync.Documents = Backbone.Collection.extend
  model: CodeSync.Document

helpers =
  processStyleContent: (content)->
    $('head style[data-codesync-document]').remove()
    $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

  processScriptContent: (code)->
    evalRunner = (code)-> eval(code)
    evalRunner.call(window, code)
