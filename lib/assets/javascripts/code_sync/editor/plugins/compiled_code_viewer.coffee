CodeSync.plugins.CompiledCodeViewer = CodeSync.ToolbarPanel.extend
  buttonIcon: "code"
  availableInModes: "all"
  handle: "compiledCodeViewer"

  hide: ()->
    @visible = false
    if @previousDocument
      @editor.loadDocument(@previousDocument)

  # Show enables the compiled
  show: ()->
    @visible = true
    @previousDocument = @editor.currentDocument
    @editor.loadDocument @previousDocument.toCompiledDocument()

  render: ()->
    @checkAvailabilityInMode()
    @rendered = true
    @