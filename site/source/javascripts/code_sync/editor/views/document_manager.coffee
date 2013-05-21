CodeSync.plugins.DocumentManager = Backbone.View.extend

  views: {}

  events:
    "click .document-tab.selectable" : "onDocumentTabSelection"
    "click .document-tab.closable .close-anchor" : "closeTab"
    "click .document-tab.new-document" : "createDocument"
    "click .document-tab.save-document" : "saveDocument"
    "click .document-tab.open-document": "toggleAssetSelector"

    "dblclick .document-tab.editable" : "onDoubleClickTab"

    "blur .document-tab.editable .contents" : "onEditableTabBlur"
    "keydown .document-tab.editable .contents" : "onEditableTabKeyPress"

  initialize: (options={})->
    @editor = options.editor

    @$el.append "<div class='document-tabs-container' />"

    @openDocuments = new CodeSync.Documents()

    @openDocuments.on "add", @renderTabs, @
    @openDocuments.on "remove", @renderTabs, @
    @openDocuments.on "change:display", @renderTabs, @

    @projectAssets = new CodeSync.ProjectAssets()

    @state = new Backbone.Model
      currentDocument: undefined

    @state.on "change:currentDocument", @highlightActiveDocumentTab, @

    @on "editor:hidden", ()=>
      @$('.document-tab.hideable').hide()

    @on "editor:visible", ()=>
      @$('.document-tab.hideable').show()
      @toggleSaveButton()

    @views.assetSelector = new CodeSync.AssetSelector
      collection: @projectAssets
      documents: @openDocuments
      editor: @editor

    @views.assetSelector.on "asset:selected", @onAssetSelection, @

  documentInTab: (tabElement)->
    tabElement = tabElement.parents('.document-tab').eq(0) unless tabElement.is('.document-tab')

    if cid = tabElement.data('document-cid')
      doc = @openDocuments.detect (model)->
        model.cid == cid

  renderTabs: ()->
    container = @$('.document-tabs-container').empty()
    tmpl = JST["code_sync/editor/templates/document_manager_tab"]

    # Render each document into a tab
    @openDocuments.each (doc,index)-> container.append tmpl(doc: doc, index: index)

    if @allowNew is true
      container.append tmpl(display:"New",cls:"new-document")

    if @allowOpen is true
      container.append tmpl(display:"Open",cls:"open-document")

  onAssetSelection: (path)->
    @openDocuments.findOrCreateForPath path, (doc)=>
      @openDocument(doc)

  onEditableTabKeyPress: (e)->
    target = @$(e.target).closest('.document-tab')
    contents = target.children('.contents')

    if e.keyCode is 13 or e.keyCode is 27
      e.preventDefault()

      contents.attr('contenteditable', false)

      if doc = @documentInTab(target)
        if e.keyCode is 13
          doc.set('name', contents.html() )

        if e.keyCode is 27 and original = target.attr('data-original-value')
          contents.html(original)

      @editor.codeMirror.focus()

  onEditableTabBlur: (e)->
    target = @$(e.target).closest('.document-tab')
    contents = target.children('.contents')

    console.log "On Editable Tab Blur", @documentInTab(target)?.cid
    if doc = @documentInTab(target)
      doc.set('name', contents.html() )
      contents.attr('contenteditable', false)

  onDoubleClickTab: (e)->
    target = @$(e.target).closest('.document-tab')
    contents = target.children('.contents')

    target.attr('data-original-value', contents.html())
    contents.attr('contenteditable',true)

  onDocumentTabSelection: (e)->
    @trigger "tab:click"
    target = @$(e.target).closest('.document-tab')
    doc = @documentInTab(target)

    @setCurrentDocument(doc)

  closeTab: (e)->
    target = @$(e.target)
    doc = @documentInTab(target)

    index = @openDocuments.indexOf(doc)
    @openDocuments.remove(doc)

    @setCurrentDocument( @openDocuments.at(index - 1) || @openDocuments.at(0) )

  getCurrentDocument: ()->
    @currentDocument

  openDocument: (doc)->
    @openDocuments.add(doc)
    @setCurrentDocument(doc)

  setCurrentDocument: (@currentDocument)->
    @editor.loadDocument(@currentDocument)

  toggleSaveButton: ()->
    if @currentDocument?.get("path")?.length > 0
      @$('.save-document').show()
    else
      @$('.save-document').hide()

  saveDocument: ()->
    if CodeSync.get("disableAssetSave")
      @editor.showStatusMessage(type: "error", message: "Saving is disabled in this demo.")
    else
      @currentDocument.saveToDisk()

  createDocument: ()->
    @openDocuments.add
      name: "untitled"
      display: "Untitled"
      mode: CodeSync.get("defaultFileType")
      extension: CodeSync.Modes.guessExtensionFor(CodeSync.get("defaultFileType"))

    doc = @openDocuments.last()

    @openDocument(doc)

  toggleAssetSelector: ()->
    @views.assetSelector.toggle()

  render: ()->
    @$el.append( @views.assetSelector.render().el )

    @


CodeSync.plugins.DocumentManager.setup = (editor)->
  dm = @views.documentManager = new CodeSync.plugins.DocumentManager(editor: @)

  _.extend editor.codeMirrorKeyBindings,
    "Ctrl-T": ()->
      dm.toggleAssetSelector()

    "Ctrl-S": ()->
      dm.getCurrentDocument().save()

    "Ctrl-N": ()->
      dm.createDocument()

  @$el.append(dm.render().el)

  dm.on "tab:click", ()=>
    @show() if @visible is false

  CodeSync.AssetEditor::loadDefaultDocument = ()->
    defaultDocument = editor.getDefaultDocument()
    dm.openDocument(defaultDocument)
