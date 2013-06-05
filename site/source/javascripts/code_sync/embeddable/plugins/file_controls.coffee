CodeSync.plugins.FileControls = CodeSync.EditorUtility.extend
  buttonIcon: "save"

  handle: "fileControls"

  availableInModes: "all"

  className: "file-controls"

  panelTemplate: "file_controls"

  tooltip: "Open, Save, Create, etc."

  events:
    "click .save-to-disk":                "saveToDisk"
    "click .load-from-disk":              "loadFromDisk"
    "click .compile":                     "compileDocument"

    "focus .read-only": (e)-> $(e.target).blur()

    "keyup input.modifiable":             "updateDocumentAttributes"
    "blur input.modifiable":              "updateDocumentAttributes"

  initialize: (@options={})->
    _.extend(@, @options)
    CodeSync.EditorUtility::initialize.apply @, arguments

    @updateDocumentAttributes = _.debounce(@updateDocumentAttributes, 400)

  show: ()->
    @syncWithDocument()
    CodeSync.EditorUtility::show.apply(@, arguments)

  saveToDisk: ()->
    @doc.set("doNotSave", false)
    @doc.saveToDisk()

  loadFromDisk: ()->
    @doc.loadSourceFromDisk()

  compileDocument: ()->
    @doc.set("doNotSave", false)
    @doc.sendToServer(false)

  updateDocumentAttributes: ()->
    name    = @$('#document_name').val()
    folder  = @$('#document_folder').val()
    path    = (CodeSync.get("projectRoot") + "/#{ folder }/#{ name }").replace("//","/")

    @doc.set {path,name,folder}

  templateOptions: ()->
    name: @doc.nameWithExtension()
    path: @doc.get("path")
    folder: @doc.folder()
    newPath: @doc.newPath()

  syncWithDocument: ()->
    if old = @doc
      @doc.off "change", @applyTemplate

    if @doc = @editor.currentDocument
      @doc.on "change", @applyTemplate, @

    @applyTemplate()





