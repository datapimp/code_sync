CodeSync.plugins.DocumentManager = Backbone.View.extend

  views: {}

  events:
    "click .document-tab.selectable" : "onDocumentTabSelection"
    "click .document-tab.closable .close-anchor" : "closeTab"
    "click .document-tab.new-document" : "createDocument"
    "click .document-tab.open-document": "toggleAssetSelector"

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

      container.append "<div class='document-tab selectable #{ cls }' data-document-id='#{ documentModel.id }' data-document-index='#{ index }'>#{ documentModel.get('display') } #{ closeAnchor }</div>"

    container.append "<div class='document-tab static new-document hideable'>New</div>"
    container.append "<div class='document-tab static open-document hideable'>Open</div>"

    @

  onAssetSelection: (path)->
    @openDocuments.findOrCreateForPath path, (documentModel)=>
      @loadDocument(documentModel)

  onDocumentTabSelection: (e)->
    @trigger "tab:click"
    target = @$(e.target).closest('.document-tab')
    documentModel = @openDocuments.at target.data('document-index')
    @loadDocument(documentModel)

  closeTab: (e)->
    target = @$(e.target).closest('.document-tab')
    documentModel = @openDocuments.at target.data('document-index')
    @openDocuments.remove(documentModel)

  getCurrentDocument: ()->
    @state.get("currentDocument")

  loadDocument: (documentModel)->
    @state.set "currentDocument", documentModel
    @trigger "document:loaded", documentModel

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