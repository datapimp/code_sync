CodeSync.DocumentManager = Backbone.Model.extend
  initialize: (@attributes={})->
    @editor = @attributes.editor
    delete @attributes.editor

    @openDocuments = new CodeSync.Documents()

    for trigger in ["add","remove","change:display","change:sticky"]
      @openDocuments.on(trigger, @notify, @)

    Backbone.Model::initialize.apply(@,arguments)

  # In multiple setups with multiple editors
  # the DocumentManager can act as a singleton
  # and route documents to multiple editors
  getEditor: ()->
    @editor || _(CodeSync.AssetEditor.instances).values()[0]

  detect: (iterator)->
    @openDocuments.each(iterator)

  each: (iterator)->
    @openDocuments.each(iterator)

  notify: ()->
    @trigger "document:change"

  openDocument: (doc, editor)->
    editor ||= @getEditor()

    @openDocuments.add(doc)
    @setCurrentDocument(doc, editor)

  setCurrentDocument: (@currentDocument, editor)->
    editor ||= @editor
    editor.loadDocument(@currentDocument)

  saveDocument: ()->
    if CodeSync.get("disableAssetSave")
      @getEditor().showError("Saving is disabled.")
    else
      @currentDocument.saveToDisk()

  createDocument: (editor)->
    editor      ||= @getEditor()
    mode        = editor.mode?.id || CodeSync.get("defaultFileType")
    extension   = CodeSync.Modes.guessExtensionFor(mode)

    doc = new CodeSync.Document
      name: "untitled"
      display: "Untitled"
      mode: mode
      extension: extension

    @openDocument(doc,editor)
