CodeSync.plugins.DocumentTabs = Backbone.View.extend
  className: "document-tabs"
  # Save, Open, New tabs
  includeActionTabs: true

  allowNew: true

  allowOpen: true

  allowSave: (CodeSync.get("allowSaving") is true)

  events:
    "click .selectable" :             "onDocumentTabSelection"
    "click .closable .close-anchor":  "closeTab"
    "click .new-document" :           "createDocument"
    "click .save-document" :          "saveDocument"
    "click .open-document":           "toggleAssetSelector"
    "dblclick .editable":             "onDoubleClickTab"
    "blur .editable .contents":       "onEditableTabBlur"
    "keydown .editable .contents":    "onEditableTabKeyPress"


  tabTemplate: JST["code_sync/editor/templates/document_manager_tab"]

  views: {}

  initialize: (@options={})->
    _.extend(@, options)

    @editor     = options.editor
    @manager    = @editor.documentManager
    @docs       = @manager.openDocuments

    @manager.on "document:change", @renderTabs, @

    @projectAssets = new CodeSync.ProjectAssets()

    @on "editor:hidden", ()=>
      @$('.document-tab.hideable').hide()

    @on "editor:visible", ()=>
      @$('.document-tab.hideable').show()

    @views.assetSelector = new CodeSync.AssetSelector
      collection: @projectAssets
      documents: @docs
      editor: @editor

    @views.assetSelector.on "asset:selected", @onAssetSelection, @

    Backbone.View::initialize.apply(@, arguments)

  tabsContainer: ()->
    el = @$('.document-tabs-container')

  documentInTab: (tabElement)->
    tabElement = tabElement.parents('.document-tab').eq(0) unless tabElement.is('.document-tab')

    if cid = tabElement.data('document-cid')
      doc = @docs.detect (model)->
        model.cid == cid

  renderTabs: ()->
    container = @tabsContainer().empty()

    tmpl = @tabTemplate

    @docs.each (doc,index)=>
      unless @skipTabForDefault is true and index is 0
        container.append tmpl(doc: doc, index: index, closable: !!(index > 0))

    if @includeActionTabs
      @addOpenDocumentTab() if @allowOpen
      @addNewDocumentTab() if @allowNew

  addOpenDocumentTab: ()->
    @tabsContainer().append @tabTemplate(display:"Open",cls:"open-document")

  addNewDocumentTab: ()->
    @tabsContainer().append @tabTemplate(display:"New",cls:"new-document")

  addSaveDocumentTab: ()->
    @tabsContainer().append @tabTemplate(display:"Save",cls:"save-document")

  onAssetSelection: (path)->
    @docs.findOrCreateForPath path, (doc)=>
      @manager.openDocument(doc, @editor)

  onEditableTabKeyPress: (e)->
    target = @$(e.target).closest('.document-tab')
    contents = target.children('.contents')

    console.log "On Editable Tab Keypress", e.keyCode, e.which

    if e.keyCode is 13 or e.keyCode is 27
      e.preventDefault()

      contents.attr('contenteditable', false)

      if doc = @documentInTab(target)
        if e.keyCode is 13
          doc.set('name', contents.html() )

        if e.keyCode is 27 and original = target.attr('data-original-value')
          contents.html(original)

      @restoreFocus()

  restoreFocus: ()->
    @editor.codeMirror.focus()

  onEditableTabBlur: (e)->
    console.log "On Editable Tab Blur"

    target = @$(e.target).closest('.document-tab')
    contents = target.children('.contents')

    if doc = @documentInTab(target)
      doc.set('name', contents.html() )
      contents.attr('contenteditable', false)

  onDoubleClickTab: (e)->
    console.log "On Double Click Tab"

    target = @$(e.target).closest('.document-tab')
    contents = target.children('.contents')

    target.attr('data-original-value', contents.html())
    contents.attr('contenteditable',true)

  onDocumentTabSelection: (e)->
    @trigger "tab:click"
    target = @$(e.target).closest('.document-tab')
    doc = @documentInTab(target)

    @manager.setCurrentDocument(doc, @editor)

  closeTab: (e)->
    target = @$(e.target)
    doc = @documentInTab(target)

    index = @docs.indexOf(doc)
    @docs.remove(doc)

    @manager.setCurrentDocument( @docs.at(index - 1) || @docs.at(0), @editor )

  createDocument: ()->
    @manager.createDocument()

  toggleAssetSelector: ()->
    @views.assetSelector.toggle()

  render: ()->
    @$el.append "<div class='document-tabs-container' />"
    @$el.append( @views.assetSelector.render().el )

    @


CodeSync.plugins.DocumentTabs.setup = (editor, options={})->
  options.editor = editor

  dm = @views.documentTabs = new CodeSync.plugins.DocumentTabs(options)

  if editor.position is "top"
    @$el.append(dm.render().el)

  if editor.position is "bottom"
    @$el.append(dm.render().el)

  dm.on "tab:click", ()=>
    @show() if @visible is false
