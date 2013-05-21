# Triggers
#
# status:
#   - success

CodeSync.Document = Backbone.Model.extend
  callbackDelay: 150

  initialize: (@attributes,options)->
    if localKey = @attributes.localStorageKey
      @attributes.contents ||= localStorage.getItem(localKey)

    Backbone.Model::initialize.apply(@, arguments)

    _.bindAll @, "onContentChange"

    @on "change:contents", @onContentChange

    @on "change:name", ()=>
      @set("mode", @determineMode())
      @set("display", @nameWithoutExtension() )

    @on "change:mode", ()=>
      @set('extension', @determineExtension(), silent: true)

  url: ()->
    CodeSync.get("assetCompilationEndpoint")

  saveToDisk: ()->
    if @isSaveable()
      @sendToServer(true, "saveToDisk")

  saveToLocalStorage: (path)->
    if path?
      localStorage.setItem(path, @get("contents"))

  loadSourceFromDisk: (callback)->
    $.ajax
      url: "#{ @url() }?path=#{ @get('path') }"
      type: "GET"
      success: (response={})=>
        if response.success is true and response.contents?
          @set("contents", response.contents, silent: true)
          callback(@)

  toJSON: ()->
    name: @nameWithoutExtension()
    path: @get('path')
    extension: @get('extension') || @determineExtension()
    contents: @toContent()

  nameWithoutExtension: ()->
    extension = @get('extension') || @determineExtension()
    (@get("name") || "untitled").replace(extension,'')

  toMode: ()->
    mode = @get("mode") || @determineMode()
    modeModel = CodeSync.Modes.getMode(mode)

  toCodeMirrorMode: ()->
    @toMode()?.get("codeMirrorMode")

  toCodeMirrorDocument: ()->
    CodeMirror.Doc @toContent(), @toCodeMirrorMode(), 0

  toCodeMirrorOptions: ()->
    @toMode().get("codeMirrorOptions")

  toContent: ()->
    "#{ @get("contents") || @toMode()?.get("defaultContent") || " " }"

  onContentChange: ()->
    localKey = @get("localStorageKey")
    localKey = if localKey? && _.isFunction(localKey) then localKey.call(@) else localKey
    localStorage.setItem(localKey, @get("contents"))

    @sendToServer(false, "onContentChange")

  sendToServer: (allowSaveToDisk=false, reason="")->
    allowSaveToDisk = false unless @isSaveable()

    data = if allowSaveToDisk is true then @toJSON() else _(@toJSON()).pick('name','extension','contents')

    CodeSync.log("Sending Data To #{ CodeSync.get("assetCompilationEndpoint") }", data)

    $.ajax
      type: "POST"
      url: CodeSync.get("assetCompilationEndpoint")
      data: JSON.stringify(data)
      error: (response)=>
        CodeSync.log("Document Process Error", arguments)

      success: (response)=>
        CodeSync.log("Document Process Response", response)

        if response.success is true
          @trigger "status", type: "success", message: @successMessage(reason), compiled: response.compiled

        if response.success is true and response.compiled?
          @set("compiled", response.compiled)

        if response.success is false and response.error?
          @set("error", response.error?.message)
          @trigger "status", type: "error", message: response.error?.message

  loadInPage: (options={})->
    if @type() is "stylesheet"
      helpers.processStyleContent.call(@, @get('compiled'))
    else if (@type() is "script" or @type() is "template")
      helpers.processScriptContent.call(@, @get('compiled'))

      if options.complete
        _.delay(options.complete, (options.delay||@callbackDelay))

  # Determines how we will handle the compiled assets when loading in the page
  type: ()->
    switch @get("mode")
      when "css","sass","scss","less"
        "stylesheet"
      when "coffeescript","javascript"
        "script"
      when "skim","mustache","jst","haml","eco"
        "template"

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

  successMessage: (reason)->
    if @type() is "template"
      "Success.  Template will be available as JST[\"#{ @nameWithoutExtension() }\"]"

  isSticky: ()->
    @get("sticky")? is true

  isSaveable: ()->
    @get("path")?.length > 0 && !@get("doNotSave")

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

      documentModel.loadSourceFromDisk ()=>
        callback?(documentModel)

helpers =
  processStyleContent: (content)->
    $('head style[data-codesync-document]').remove()
    $('head').append "<style type='text/css' data-codesync-document=true>#{ content }</style>"

  processScriptContent: (code)->
    doc = @
    evalRunner = (code)->
      try
        eval(code)
      catch e
        doc.trigger "status", type: "error", message: "JS Error: #{ e.message }", sticky: true
        throw(e)

    evalRunner.call(window, code)
