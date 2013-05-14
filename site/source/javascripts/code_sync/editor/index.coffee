#= require skim
#= require_tree ./templates
#= require_tree ./datasources
#= require_tree ./views
#= require_self

CodeSync.AssetEditor = Backbone.View.extend

  className: "codesync-editor"

  autoRender: true

  position: "top"

  effect: "slide"

  effectDuration: 400

  editorChangeThrottle: 800

  visible: false

  showVisibleTab: true

  events:
    "click .status-message" : (e)->
      target = $(e.target).closest('.status-message')
      target.remove()

  plugins:[
    "DocumentManager"
    "ModeSelector"
    "PreferencesPanel"
  ]

  initialize: (@options={})->
    _.extend(@, @options)

    _.bindAll(@, "editorChangeHandler")

    @views = {}

    @$el.addClass "#{ @position }-positioned"

    @render() unless @autoRender is false

    @on "editor:change", _.debounce(@editorChangeHandler, @editorChangeThrottle), @

  setupCodeMirror: ()->
    return if @codeMirror?

    @height ||= @$el.height()
    @codeMirror = CodeMirror(@$('.codesync-asset-editor')[0], @getCodeMirrorOptions())

    @trigger "codemirror:setup"

    changeHandler = (changeObj)=>
      @trigger "editor:change", @codeMirror.getValue(), changeObj

    @codeMirror.on "change", _.debounce(changeHandler, @editorChangeThrottle)

    #@codeMirror.on "focus", ()=> @views.preferencesPanel.$el.hide()

    @

  codeMirrorKeyBindings:
    "Ctrl-J": ()->
      @toggle()


  getCodeMirrorOptions: ()->
    for keyCommand, handler of @codeMirrorKeyBindings
      @codeMirrorKeyBindings[keyCommand] = _.bind(handler, @)

    options =
      theme: 'lesser-dark'
      lineNumbers: true
      mode: CodeSync.Modes.guessModeFor(@defaultExtension)
      extraKeys: @codeMirrorKeyBindings

  editorChangeHandler: (editorContents)->
    documentModel = @views.documentManager.getCurrentDocument()
    documentModel.set("contents", editorContents)

  render: ()->
    return @ if @rendered is true

    @$el.html JST["code_sync/editor/templates/asset_editor"]()

    for plugin in @plugins when CodeSync.plugins[plugin]?
      PluginClass = CodeSync.plugins[plugin]
      PluginClass.setup.call(@, @)

    @delegateEvents()
    @rendered = true

    @

  onDocumentLoad: (doc)->
    if @currentDocument?
      @currentDocument.off "status", @showStatusMessage
      @currentDocument.off "change:compiled", @loadDocumentInPage
      @currentDocument.off "change:mode", @loadDocumentInPage, @

    @currentDocument = doc

    @trigger "document:loaded", doc

    @codeMirror.swapDoc @currentDocument.toCodeMirrorDocument()

    @currentDocument.on "status", @showStatusMessage, @
    @currentDocument.on "change:compiled", @loadDocumentInPage, @
    @currentDocument.on "change:mode", @loadDocumentInPage, @


  loadDocumentInPage: ()->
    @currentDocument?.loadInPage complete: ()=>
      if @currentDocument?.type() is "script"
        CodeSync.onScriptChange?.call(window, @currentDocument.attributes)

      if @currentDocument?.type() is "stylesheet"
        CodeSync.onStylesheetChange?.call(window, @currentDocument.attributes)

  loadAdhocDocument: ()->
    documentModel = @views.documentManager.createAdHocDocument()
    @views.documentManager.loadDocument(documentModel)

  showStatusMessage:(options={})->
    @$('.status-message').remove()
    @$el.prepend "<div class='status-message #{ options.type }'>#{ options.message }</div>"

    if options.type is "success"
      _.delay ()=>
        @$('.status-message').animate({opacity:0}, duration: 400, complete: ()=> @$('.status-message').remove())
      , 1200

  effectSettings: ()->
    switch @effect

      when "slide"
        if @visible is true and @position is "top"
          offset = if @showVisibleTab then @$('.document-tabs-container').height() else 0
          top: "#{ ((@height + 5) * -1 + offset) }px"
        else
          top: "0px"

      when "fade"
        if @visible is true
          opacity: 0
        else
          opacity: 0.98


  hide: (withEffect=true)->
    @animating = true

    view.trigger("editor:hidden") for viewName, view of @views

    completeFn = _.debounce ()=>
      @visible = false
      @animating = false
    , @effectDuration + 20

    if withEffect is true
      @$el.animate @effectSettings(), duration: @effectDuration, complete: completeFn
      _.delay(completeFn, @effectDuration)
    else
      completeFn()

    @

  show: (withEffect=true)->
    @setupCodeMirror()

    @animating = true

    view.trigger("editor:visible") for viewName, view of @views

    completeFn = _.debounce ()=>
      @visible = true
      @animating = false
    , @effectDuration

    if withEffect is true
      @$el.animate @effectSettings(), duration: @effectDuration, complete: completeFn
      _.delay(completeFn, @effectDuration)
    else
      completeFn()

    @

  toggle: ()->
    return if @animating is true

    if @visible is true
      @hide(true)
    else
      @show(true)

  setKeyMap: (keyMap)->
    @codeMirror.setOption 'keyMap', keyMap

  setTheme: (theme)->
    @codeMirror.setOption 'theme', theme

  setMode: (@mode)->
    if !_.isString(@mode)
      codeMirrorMode = @mode.get("codeMirrorMode")

    @codeMirror.setOption 'mode', codeMirrorMode
    @currentDocument.set('mode', @mode.get("codeMirrorMode"))
    @currentDocument.set('extension', CodeSync.Modes.guessExtensionFor(@mode.get("codeMirrorMode")) )

    @


# Private Helpers

CodeSync.AssetEditor.keyboardShortcutInfo = """
ctrl+j: toggle editor ctrl+t: open asset
"""

CodeSync.AssetEditor.toggleEditor = _.debounce (options={})->
  if window.codeSyncEditor?
    window.codeSyncEditor.toggle()
  else
    window.codeSyncEditor = new CodeSync.AssetEditor(options)
    $('body').prepend(window.codeSyncEditor.render().el)
    window.codeSyncEditor.show()
, 1

CodeSync.AssetEditor.setHotKey = (hotKey, options={})->
  key(hotKey, ()-> CodeSync.AssetEditor.toggleEditor(options))
