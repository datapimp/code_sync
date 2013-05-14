CodeSync.plugins.DocumentManager = Backbone.View.extend

  events:
    "click .document-tab" : "onTabClick"
    "click .document-tab.closable .close-anchor" : "closeTab"

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
      @$('.document-tab.closable').hide()

    @on "editor:visible", ()=>
      @$('.document-tab.closable').show()


  renderTabs: ()->
    container = @$('.document-tabs-container').empty()

    for documentModel,index in @openDocuments.models
      cls = ""
      closeAnchor = ""

      unless documentModel.id is 1
        cls = 'closable'
        closeAnchor = "<small class='close-anchor'>x</small>"

      container.append "<div class='document-tab #{ cls }' data-document-index='#{ index }'>#{ documentModel.get('display') } #{ closeAnchor }</div>"

    @

  onTabClick: (e)->
    @trigger "tab:click"
    target = @$(e.target).closest('.document-tab')
    documentModel = @openDocuments.at target.data('document-index')
    @loadDocument(documentModel)

  closeTab: (e)->
    target = @$(e.target).closest('.document-tab')
    documentModel = @openDocuments.at target.data('document-index')
    @openDocuments.remove(documentModel)

  highlightActiveDocumentTab: ()->

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

  render: ()->
    @loadDocument @createAdHocDocument()
    @


CodeSync.plugins.DocumentManager.setup = (editor)->
  dm = @views.documentManager = new CodeSync.plugins.DocumentManager(editor: @)

  _.extend editor.codeMirrorKeyBindings,
    "Ctrl-S": ()->
      dm.getCurrentDocument().save()

    "Ctrl-N": ()->
      dm.createDocument()


  @$el.append(dm.render().el)

  @on "codemirror:setup", @loadAdhocDocument, @

  dm.on "tab:click", ()=>
    @show() if @visible is false

  dm.on "document:loaded", (doc)=>
    if @currentDocument?
      @currentDocument.off "status", @showStatusMessage

    @codeMirror.swapDoc doc.toCodeMirrorDocument()
    @currentDocument = doc

    @currentDocument.on "status", @showStatusMessage, @

    @currentDocument.on "change:compiled", ()=>
      @currentDocument.loadInPage()