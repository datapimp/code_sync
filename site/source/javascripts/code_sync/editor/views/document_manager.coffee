CodeSync.plugins.DocumentManager = Backbone.View.extend

  views: {}

  events:
    "click .document-tab.selectable" : "onDocumentTabSelection"
    "click .document-tab.closable .close-anchor" : "closeTab"
    "click .document-tab.new-document" : "createDocument"
    "click .document-tab.save-document" : "saveDocument"
    "click .document-tab.open-document": "toggleAssetSelector"
    "dblclick .document-tab.selectable" : "onDoubleClickTab"

    "blur .document-tab.editable .contents" : "onEditableTabBlur"
    "keypress .document-tab.editable .contents" : "onEditableTabKeyPress"

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

  renderTabs: ()->
    container = @$('.document-tabs-container').empty()

    for documentModel,index in @openDocuments.models
      cls = ""
      closeAnchor = ""

      unless documentModel.id is 1
        cls = 'closable hideable'
        closeAnchor = "<small class='close-anchor'>x</small>"

      container.append "<div class='document-tab selectable #{ cls }' data-document-id='#{ documentModel.id }' data-document-index='#{ index }'><span class='contents'>#{ documentModel.get('display') }</span> #{ closeAnchor }</div>"

    container.append "<div class='document-tab static new-document hideable'>New</div>"

    unless CodeSync.get("disableAssetOpen") is true
      container.append "<div class='document-tab static open-document hideable'>Open</div>"

    container.append "<div class='document-tab static save-document hideable'>Save</div>"

    @

  onAssetSelection: (path)->
    @openDocuments.findOrCreateForPath path, (documentModel)=>
      @loadDocument(documentModel)

  onEditableTabKeyPress: (e)->

    target = @$(e.target).closest('.document-tab')
    content = @$('.contents',target)

    if e.keyCode is 13
      e.preventDefault()
      target.removeClass('editable')
      content.attr('contenteditable', false)

      if documentModel = @openDocuments.at target.data('document-index')
        documentModel.set('name', content.html() )

      @editor.codeMirror.focus()


  onEditableTabBlur: (e)->
    target = @$(e.target).closest('.document-tab')
    content = @$('.contents', target)

    if documentModel = @openDocuments.at target.data('document-index')
      documentModel.set('name', content.html() )
      content.attr('contenteditable', false)

  onDoubleClickTab: (e)->
    target = @$(e.target).closest('.document-tab')
    target.addClass('editable')

    if documentModel = @openDocuments.at target.data('document-index')
      @loadDocument(documentModel)

    @$('.contents',target).attr('contenteditable',true)

  onDocumentTabSelection: (e)->
    @trigger "tab:click"
    target = @$(e.target).closest('.document-tab')
    documentModel = @openDocuments.at target.data('document-index')
    @loadDocument(documentModel)

  closeTab: (e)->
    target = @$(e.target).closest('.document-tab')
    index = target.data('document-index')
    documentModel = @openDocuments.at(index)
    @openDocuments.remove(documentModel)

    @loadDocument( @openDocuments.at(index - 1) || @openDocuments.at(0) )

  getCurrentDocument: ()->
    @currentDocument

  loadDocument: (documentModel)->
    @currentDocument = documentModel
    @trigger "document:loaded", documentModel
    @toggleSaveButton()

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

    documentModel = @openDocuments.last()

    @loadDocument(documentModel)

  createAdHocDocument: ()->
    @openDocuments.add
      id: 1
      extension: ".css.sass"
      name: "scratch-pad"
      mode: "sass"
      path: undefined
      display: "CodeSync Editor"
      contents: "// Feel free to experiment with Sass"

    @openDocuments.get(1)

  toggleAssetSelector: ()->
    @views.assetSelector.toggle()

  render: ()->
    @loadDocument @createAdHocDocument()
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

  @on "codemirror:setup", @loadAdhocDocument, @

  dm.on "tab:click", ()=>
    @show() if @visible is false

  dm.on "document:loaded", editor.onDocumentLoad, @