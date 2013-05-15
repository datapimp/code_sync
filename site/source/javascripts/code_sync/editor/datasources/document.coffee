CodeSync.Document = Backbone.Model.extend
  callbackDelay: 150

  initialize: (@attributes,options)->
    Backbone.Model::initialize.apply(@, arguments)

    @on "change:contents", @process, @

    @on "change:name", ()=>
      @set("mode", @determineMode(), silent: false)

    @on "change:mode", ()=>
      @set('extension', @determineExtension(), silent: true)

  url: ()->
    CodeSync.get("assetCompilationEndpoint")

  saveToDisk: ()->
    console.log "Document Save To Disk", @get("path"), @get("path")?.length

    if @get("path")?.length > 0
      @process(true, "Save To Disk")

  loadSourceFromDisk: (callback)->
    $.ajax
      url: "#{ @url() }?path=#{ @get('path') }"
      type: "GET"
      success: (response={})=>
        if response.success is true and response.contents?
          @set("contents", response.contents, silent: true)
          callback(@)


  # Meh this isn't working so great
  applyDefaults: ()->
    @attributes = _.defaults @attributes,
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

  process: (allowSaveToDisk=false)->
    data = if allowSaveToDisk is true then @toJSON() else _(@toJSON()).pick('name','extension','contents')

    console.log "Process", arguments, data

    $.ajax
      type: "POST"
      url: CodeSync.get("assetCompilationEndpoint")
      data: JSON.stringify(data)
      success: (response)=>
        console.log "Process Response", response
        if response.success is true
          @trigger "status", type: "success", message: "Success"

        if response.success is true and response.compiled?
          @set("compiled", response.compiled)

        if response.success is false and response.error?
          @set("error", response.error?.message)
          @trigger "status", type: "error", message: response.error?.message

  loadInPage: (options={})->
    if @type() is "stylesheet"
      helpers.processStyleContent.call(@, @get('compiled'))
    else if @type() is "script"
      helpers.processScriptContent.call(@, @get('compiled'))

      if options.complete
        _.delay(options.complete, (options.delay||@callbackDelay))

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
    filename = @get("path") || @get("name")

    if extension = CodeSync.Document.getExtensionFor(filename)
      return extension

    if @get("mode")?
      return CodeSync.Modes.guessExtensionFor( @get('mode') || CodeSync.get("defaultFileType")  )

  # Determine a CodeMirror mode setting appropriate for the file extension
  determineMode: ->
    path = @get("path") || @get("name") || @get("extension")
    CodeSync.Modes.guessModeFor(path)

CodeSync.Document.getFileNameFrom = (string="")->
  string.split('/').pop()

CodeSync.Document.getExtensionFor = (string="")->
  filename = CodeSync.Document.getFileNameFrom(string)

  [fname,rest...] = filename.split('.')

  if val = rest.length > 0 && rest.join('.')
    ".#{ val }"

CodeSync.Documents = Backbone.Collection.extend
  model: CodeSync.Document

  nextId: ()->
    @models.length + 1

  findOrCreateForPath: (path="", callback)->
    documentModel = @detect (documentModel)->
      documentModel.get('path')?.match(path)

    if documentModel?
      callback?(documentModel)
    else
      name = CodeSync.Document.getFileNameFrom(path)
      extension = CodeSync.Document.getExtensionFor(name)
      display = name.replace(extension,'')
      id = @nextId()

      documentModel = new CodeSync.Document({name,extension,display,path,id})
      documentModel.applyDefaults()

      documentModel.loadSourceFromDisk ()=>
        @add(documentModel)
        callback?(documentModel)

helpers =
  processStyleContent: (content)->
    $('head style[data-codesync-document]').remove()
    $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

  processScriptContent: (code)->
    evalRunner = (code)-> eval(code)
    evalRunner.call(window, code)
