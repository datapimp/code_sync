CodeSync.plugins.FileControls = CodeSync.ToolbarPanel.extend
  buttonIcon: "save"

  handle: "fileControls"

  availableInModes: "all"

  className: "file-controls"

  panelTemplate: "file_controls"

  tooltip: "Open, Save, Create, etc."

  events:
    "click .save-button": "saveDocument"
    "click .reload-button": "reloadDocument"

  initialize: (@options={})->
    _.extend(@, @options)
    CodeSync.ToolbarPanel::initialize.apply @, arguments

  show: ()->
    @syncWithDocument()
    CodeSync.ToolbarPanel::show.apply(@, arguments)

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





