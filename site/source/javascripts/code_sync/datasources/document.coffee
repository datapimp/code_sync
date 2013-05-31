# Triggers
#
# status:
#   - success

CodeSync.Document = Backbone.Model.extend

  initialize: (@attributes,options)->
    Backbone.Model::initialize.apply(@, arguments)

    _.bindAll @, "onContentChange"

    @on "change:contents", @onContentChange

    @on "change:name", ()=>
      @set("mode", @determineMode())
      @set("display", @nameWithoutExtension() )

    @on "change:mode", ()=>
      @set('extension', @determineExtension(), silent: true)

    if @localStorageKey()
      @set("contents", localStorage.getItem(@localStorageKey()), silent: true)

    @saveToLocalStorage = _.debounce(@saveToLocalStorage, 1000)

  url: ()->
    CodeSync.get("assetCompilationEndpoint")

  templateFunction: ()->
    JST[@nameWithoutExtension()]

  folder: ()->
    unless folder = @get("folder")
      if path = @get("path")
        folder = path = path.replace(@nameWithExtension(), '')

        if projectRoot = CodeSync.get("projectRoot")
          folder = path.replace(projectRoot,'')
      else
        folder = switch @type()
          when "script", "template"
            "javascripts"
          else
            "stylesheets"

    unless folder is "undefined"
      @set("folder", folder, silent: true)

    folder

  description: ()->
    if path = @get("path")
      return path.replace(CodeSync.get('projectRoot'), '')

    return "#{ @folder() }/#{ @nameWithExtension() }"

  newPath: ()->
    "#{ CodeSync.get('projectRoot') }/#{ @folder() }"

  saveToDisk: ()->
    if @isSaveable()
      @sendToServer(true, "saveToDisk")

  localStorageKey: ()->
    "#{ @get('localStorageKey') }:#{ @get('name') }" if @get("localStorageKey")

  saveToLocalStorage: (path)->
    localKey = path || @get("path")
    localStorage.setItem(localKey, @get("contents")) if localKey?

  loadSourceFromDisk: (callback)->
    $.ajax
      url: "#{ @url() }?path=#{ @get('path') }"
      type: "GET"
      success: (response={})=>
        silent = callback?
        if response.success is true and response.contents?
          @set("contents", response.contents, silent: silent)
          callback?(@)

  toJSON: ()->
    name: @nameWithoutExtension()
    path: @get('path')
    extension: @get('extension') || @determineExtension()
    contents: @toContent()

  nameWithExtension: ()->
    name = @get("name")

    unless name.match(/\./)
      name += @get("extension")

    name

  nameWithoutExtension: ()->
    extension = @get('extension') || @determineExtension()
    (@get("name") || "untitled").replace(extension,'')

  toMode: ()->
    mode = @get("mode") || @determineMode()
    modeModel = CodeSync.Modes.getMode(mode)

  toCodeMirrorMode: ()->
    @toMode()?.get("codeMirrorMode")

  toCompiledDocument: ()->
    if @compiledDocument?
      @compiledDocument.set "contents", @get("compiled"), silent: true
      return @compiledDocument

    switch @type()
      when "template", "script"
        compileMode = "javascript"
        compiledExtension = ".js"
      when "stylesheet"
        compileMode = "css"
        compiledExtension = ".css"

    @compiledDocument = new CodeSync.Document
      doNotSave: true
      raw: true
      extension: compiledExtension
      mode: compileMode
      contents:  @get("compiled")

  toCodeMirrorDocument: ()->
    CodeMirror.Doc @toContent(), @toCodeMirrorMode(), 0

  toCodeMirrorOptions: ()->
    @toMode().get("codeMirrorOptions")

  toContent: ()->
    myContent = "#{ @get("contents") || @toMode()?.get("defaultContent") || " " }"

    if prefix = CodeSync.Document.getPrefixContentFor(@)
      myContent = "#{ prefix }\n#{ myContent }";

    myContent

  onContentChange: (document, value, options={})->
    if key = @localStorageKey()
      @saveToLocalStorage(key)

    if options.liveMode is true
      @sendToServer(false, "onContentChange")

  sendToServer: (allowSaveToDisk=false, reason="")->
    allowSaveToDisk = false unless @isSaveable()

    data = if allowSaveToDisk is true then @toJSON() else _(@toJSON()).pick('name','extension','contents')

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


  changeProcessor: CodeSync.processChangeNotification

  loadInPage: (options={})->
    doc     = @

    notification =
      type: doc.type()
      compiled: doc.get("compiled")
      complete: options.complete
      name: doc.get("name")
      path: doc.get("path")
      contents: doc.get("contents")

    1;

    payload = _.extend notification,
      error: (message)->
        doc.trigger "status", type: "error", sticky: "true", message: "JS Error: #{ message }"
      success: ()->
        doc.trigger "code:sync:#{ doc.get('type') }"

    @changeProcessor(payload, origin:"document", documentId: doc.cid)

  # Determines how we will handle the compiled assets when loading in the page
  type: ()->
    switch @get("mode")
      when "css","sass","scss","less"
        "stylesheet"
      when "coffeescript","javascript"
        "script"
      when "skim","mustache","jst","haml","eco", "html"
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

CodeSync.Document.getPrefixContentFor = (doc)->
  ""

CodeSync.Documents = Backbone.Collection.extend
  model: CodeSync.Document

  initialize: (models,options)->
    Backbone.Collection::initialize.apply(@, arguments)

  nextId: ()->
    @models.length + 1

  findByPath: (path)->
    documentModel = @detect (documentModel)->
      documentModel.get('path')?.match(path)

  findOrCreateForPath: (path="", callback)->
    if documentModel = @findByPath(path)
      callback?(documentModel)
    else
      name = CodeSync.Document.getFileNameFrom(path)
      extension = CodeSync.Document.getExtensionFor(name)
      display = name.replace(extension,'')
      id = @nextId()

      documentModel = new CodeSync.Document({name,extension,display,path,id})

      documentModel.loadSourceFromDisk ()=>
        callback?(documentModel)


CodeSync.Documents._projectAssets = undefined

CodeSync.Documents.getProjectAssets = ()->
  collection = CodeSync.Documents._projectAssets ||= new CodeSync.Documents()

  $.ajax
    type: "GET"
    url: CodeSync.get("serverInfoEndpoint")
    success: (response={})=>
      if response.project_assets?.length > 0
        collection.reset response.project_assets

  collection