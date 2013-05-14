CodeSync.Document = Backbone.Model.extend
  initialize: (@attributes,options)->
    Backbone.Model::initialize.apply(@, arguments)

    @on "change:contents", @process, @

  url: ()->
    CodeSync.get("assetCompilationEndpoint")

  defaults: ()->
    name: "untitled"
    mode: @determineMode() || CodeSync.get("defaultFileType")
    extension: @determineExtension()
    compiled: ""
    display: "Untitled"

  toJSON: ()->
    name: @get('name')
    path: @get('path')
    extension: @get('extension')
    contents: @get('contents')

  toCodeMirrorDocument: ()->
    CodeMirror.Doc @get("contents"), @get("mode"), 1

  isNew: ()->
    true

  process: ()->
    console.log "Processing", @toJSON()
    @save @toJSON(), success: ()->
      console.log "Successfully saved"

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

  # If this is an adHoc document that is not being saved to disk, or rather
  # pulled from an existing asset on disk, then we will need to create an extension
  # that is appropriate for the CodeMirror mode, for the purposes of on the fly compilation
  determineExtension: ()->
    if !@get("name") && !@get("path")
      return CodeSync.AssetEditor.guessExtensionFor CodeSync.get("defaultFileType")

    filename = @get("name")
    filename ||= if path = @get("path")
      path.split('/').pop()

    [filename,parts...] = filename.split('.')

    parts.join('.')

  # Determine a CodeMirror mode setting appropriate for the file extension
  determineMode: ->
    path = @get("path") || @get("name") || @get("extension")
    mode = CodeSync.AssetEditor.guessModeFor(path) || CodeSync.get("defaultFileType")
    mode = if mode is "scss" then "css" else mode

CodeSync.Documents = Backbone.Collection.extend
  model: CodeSync.Document

helpers =
  processStyleContent: (content)->
    $('head style[data-codesync-document]').remove()
    $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

  processScriptContent: (code)->
    evalRunner = (code)-> eval(code)
    evalRunner.call(window, code)
