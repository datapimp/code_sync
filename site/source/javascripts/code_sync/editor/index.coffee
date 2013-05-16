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

  hideable: true

  startMode: "scss"

  theme: "ambiance"

  keyBindings: ""

  events:
    "click .status-message" : "removeStatusMessages"
    "click .hide-button" : "hide"

  plugins:[
    "DocumentManager"
    "ModeSelector"
    "PreferencesPanel"
  ]

  initialize: (@options={})->
    _.extend(@, @options)

    _.bindAll(@, "editorChangeHandler")

    @views = {}

    @modes = CodeSync.Modes.get()

    @startMode = @modes.get(@startMode) || CodeSync.Modes.defaultMode()

    @setPosition(@position, false)

    @on "editor:change", _.debounce(@editorChangeHandler, @editorChangeThrottle), @

    @on "codemirror:setup", ()=>
      @loadDefaultDocument()

    @$el.html JST["code_sync/editor/templates/asset_editor"]()

    @loadPlugins()

    @render() unless @autoRender is false

  loadPlugins: ()->
    for plugin in @plugins when CodeSync.plugins[plugin]?
      PluginClass = CodeSync.plugins[plugin]
      PluginClass.setup.call(@, @)

  render: ()->
    return @ if @rendered is true

    @setupToolbar()

    @delegateEvents()

    @rendered = true

    if @autoAppend is true
      $('body').prepend(@el)

    if @renderHidden is true
      @show()

      setTimeout ()=>
        @hide()
      , 900

    @

  setupCodeMirror: ()->
    return if @codeMirror?

    @height ||= @$el.height()
    @codeMirror = CodeMirror(@$('.codesync-asset-editor')[0], @getCodeMirrorOptions())

    @on "initial:document:load", ()=>
      if @startMode
        @setMode(@startMode)

      if @keyBindings
        @setKeyMap(@keyBindings)

      if @theme
        @setTheme(@theme)

    changeHandler = (changeObj)=>
      @trigger "editor:change", @codeMirror.getValue(), changeObj

    @codeMirror.on "change", _.debounce(changeHandler, @editorChangeThrottle)

    @trigger "codemirror:setup", @codeMirror

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
      mode: (@startMode?.get("codeMirrorMode") || CodeSync.get("defaultFileType"))
      extraKeys: @codeMirrorKeyBindings

  editorChangeHandler: (editorContents)->
    @currentDocument.set("contents", editorContents)

  setPosition: (@position="top", show=true)->
    for available in ["top","bottom"] when available isnt @position
      @$el.removeClass("#{ available }-positioned")

    @$el.addClass("#{ @position }-positioned")

    @show() if show is true

    @

  setKeyMap: (keyMap)->
    @codeMirror.setOption 'keyMap', keyMap

  setTheme: (theme)->
    @$el.attr("data-theme", theme)
    @codeMirror.setOption 'theme', theme

  setMode: (newMode)->
    if @mode? and (newMode isnt @mode)
      @trigger "change:mode", newMode, newMode.id

    @mode = newMode

    if @mode?.get?
      @codeMirror.setOption 'mode', @mode.get("codeMirrorMode")
      @currentDocument.set('mode', @mode.id)
      @currentDocument.set('extension', CodeSync.Modes.guessExtensionFor(@mode.id) )

    @

  setupToolbar: ()->
    if @hideable is true
      @$('.toolbar-wrapper').append "<div class='button hide-button'>Hide</div>"

  getDefaultDocument: ()->
    defaultDocument = new CodeSync.Document
      mode: @options.startMode || CodeSync.get("defaultFileType")
      sticky: true
      doNotSave: true
      name: "codesync"
      display: "CodeSync Editor"

  # This is broken apart into separate methods
  # so that plugins can tap in
  loadDefaultDocument: ()->
    @loadDocument @getDefaultDocument()

  loadDocument: (doc)->
    if @currentDocument?
      @currentDocument.off "status", @showStatusMessage
      @currentDocument.off "change:compiled", @applyDocumentContentToPage
      @currentDocument.off "change:mode", @applyDocumentContentToPage, @
    else
      @currentDocument = doc
      @trigger "initial:document:load"

    @currentDocument = doc

    @trigger "document:loaded", doc

    @codeMirror.swapDoc @currentDocument.toCodeMirrorDocument()

    @currentDocument.on "status", @showStatusMessage, @
    @currentDocument.on "change:compiled", @applyDocumentContentToPage, @
    @currentDocument.on "change:mode", @applyDocumentContentToPage, @
    @currentDocument.on

  applyDocumentContentToPage: ()->
    if @currentDocument? && (@currentDocument.toMode() isnt @mode)
      @setMode @currentDocument.toMode()

    @currentDocument?.loadInPage complete: ()=>
      if @currentDocument.type() is "script" or @currentDocument.type() is "template"
        CodeSync.onScriptChange?.call(window, @currentDocument.attributes)

      if @currentDocument.type() is "stylesheet"
        CodeSync.onStylesheetChange?.call(window, @currentDocument.attributes)

  removeStatusMessages: ()->
    @$('.status-message').remove()

  showStatusMessage:(options={})->
    @removeStatusMessages()

    if options.message?.length > 0
      @$el.prepend "<div class='status-message #{ options.type }'>#{ options.message }</div>"

    if options.type is "success"
      _.delay ()=>
        @$('.status-message.success').animate({opacity:0}, duration: 400, complete: ()=> @$('.status-message.success').remove())
      , 1200

  hintHeight: ()->
    offset = if @showVisibleTab then @$('.document-tabs-container').height() else 0

  visibleStyleSettings: ()->
    if @position is "top"
      settings =
        top: '0px'
        bottom: 'auto'

    if @position is "bottom"
      settings =
        top: 'auto'
        bottom: '0px'
        height: '400px'

    settings

  hiddenStyleSettings: ()->
    if @position is "top"
      settings =
        top: ((@$el.height() + 8) * -1 ) + @hintHeight()
        bottom: 'auto'

    if @position is "bottom"
      settings =
        top: 'auto'
        bottom: '0px'
        height: '0px'

    settings


  hide: (withEffect=true)->
    @animating = true

    view.trigger("editor:hidden") for viewName, view of @views

    completeFn = _.debounce ()=>
      @visible = false
      @animating = false
    , @effectDuration + 20

    if withEffect isnt false
      @$el.animate @hiddenStyleSettings(), duration: @effectDuration, complete: completeFn
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

    if withEffect isnt false
      @$el.animate @visibleStyleSettings(), duration: @effectDuration, complete: completeFn
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
  CodeSync.set("editorToggleHotkey", hotKey)
  key(hotKey, ()-> CodeSync.AssetEditor.toggleEditor(options))
