#= require skim
#= require_tree ./templates
#= require_tree ./datasources
#= require_tree ./plugins
#= require_self

CodeSync.AssetEditor = Backbone.View.extend
  className: "codesync-editor"

  autoRender: true
  autoAppend: true
  appendTo: "body"

  renderVisible: true

  position: "top"

  effect: "slide"

  effectDuration: 400

  editorChangeThrottle: 800

  visible: false

  showVisibleTab: true

  hideable: true

  startMode: "scss"

  theme: "ambiance"

  name: "code_sync"

  keyBindings: ""

  events:
    "click .status-message" : "removeStatusMessages"
    "click .hide-button" : "hide"

  plugins:[
    "DocumentManager"
    "ModeSelector"
    "PreferencesPanel"
  ]

  pluginOptions: {}

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

    if @name?
      @$el.attr 'data-codesync', @name

    @loadPlugins()

    @render() unless @autoRender is false

  addPlugin: (plugin)->
    CodeSync.plugins[plugin]?.setup.call(@,@)

  loadPlugins: ()->
    for plugin in @plugins when CodeSync.plugins[plugin]?
      options = @pluginOptions[plugin] || {}
      PluginClass = CodeSync.plugins[plugin]

      PluginClass.setup.call(@,@,options)

  render: ()->
    return @ if @rendered is true

    @setupToolbar()

    @delegateEvents()

    @rendered = true

    if @autoAppend is true
      $(@appendTo).prepend(@el)

    if @renderHidden is true
      @show()

      setTimeout ()=>
        @hide()
      , 900

    if @renderVisible is true
      @show()

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

      if @theme ||= localStorage.getItem("codesync:theme")
        @setTheme(@theme)

    changeHandler = (changeObj)=>
      @trigger "editor:change", @codeMirror.getValue(), changeObj

    @codeMirror.on "change", _.debounce(changeHandler, @editorChangeThrottle)

    @trigger "codemirror:setup", @codeMirror

    @

  codeMirrorKeyBindings:
    "Ctrl+Command+1": ()->
      CodeSync.get("commandOne")?.call?(@)

    "Ctrl+Command+2": ()->
      CodeSync.get("commandTwo")?.call?(@)

    "Ctrl+Command+3": ()->
      CodeSync.get("commandThree")?.call(@)

    "Ctrl+J": ()->
      @toggle()

  getCodeMirrorOptions: ()->
    passthrough = {}

    for keyCommand, handler of @codeMirrorKeyBindings
       passthrough[keyCommand] = false
       key(keyCommand,_.bind(handler, @))

    options =
      theme: 'lesser-dark'
      lineNumbers: true
      mode: (@startMode?.get("codeMirrorMode") || CodeSync.get("defaultFileType"))
      extraKeys: passthrough

  editorChangeHandler: (editorContents)->
    @currentDocument.set("contents", editorContents)

  setPosition: (@position="top", show=true)->
    for available in ["top","bottom","static"] when available isnt @position
      @$el.removeClass("#{ available }-positioned")

    @$el.addClass("#{ @position }-positioned")
    @$el.removeAttr('style')

    @show() if show is true

    @

  setKeyMap: (keyMap)->
    if @keyMap? and keyMap isnt @keyMap
      @trigger "change:keyMap", keyMap, @keyMap
      @onKeyMapChange?.call(@,keyMap,@keyMap)

    @codeMirror.setOption 'keyMap', @keyMap = keyMap

  setTheme: (theme)->
    if @theme? and theme isnt @theme
      @trigger "change:theme", theme, @theme
      @onThemeChange?.call(@,theme,@theme)

    @$el.attr("data-codesync-theme", @theme = theme)
    @codeMirror.setOption 'theme', @theme = theme

  setMode: (newMode)->
    @$el.attr("data-codesync-mode", @mode)

    if @mode? and (newMode isnt @mode)
      @trigger "change:mode", newMode, newMode.id
      @onModeChange?.call(@,newMode,@mode)

    @mode = newMode

    if @mode?.get?
      @codeMirror.setOption 'mode', @mode.get("codeMirrorMode")
      @currentDocument.set('mode', @mode.id)
      @currentDocument.set('extension', CodeSync.Modes.guessExtensionFor(@mode.id) )

    @

  setCodeMirrorOptions: (options={})->
    for option,value of options
      @codeMirror.setOption(option,value)

  setupToolbar: ()->
    if @hideable is true
      @$('.toolbar-wrapper').append "<div class='button hide-button'>Hide</div>"

  getDefaultDocument: ()->
    defaultOptions =
      mode: @options.startMode || CodeSync.get("defaultFileType")
      sticky: true
      doNotSave: true
      name: @defaultDocumentName || "codesync"
      display: "CodeSync"

    options = _.extend(defaultOptions, @document)

    defaultDocument = new CodeSync.Document(options)

  # This is broken apart into separate methods
  # so that plugins can tap in
  loadDefaultDocument: ()->
    @loadDocument @getDefaultDocument()

  loadDocument: (doc)->
    if @currentDocument?
      @currentDocument.off "status", @showStatusMessage
      @currentDocument.off "change:compiled", @applyDocumentContentToPage
      @currentDocument.off "change:mode", @applyDocumentContentToPage, @
      @previousDocument = @currentDocument
    else
      @currentDocument = doc
      @trigger "initial:document:load"

    @currentDocument = doc

    @trigger "document:loaded", doc, @previousDocument

    @codeMirror.swapDoc @currentDocument.toCodeMirrorDocument()

    if @enableStatusMessages
      @currentDocument.on "status", @showStatusMessage, @

    @currentDocument.on "change:compiled", @applyDocumentContentToPage, @
    @currentDocument.on "change:mode", @syncEditorModeWithDocument, @

    @setCodeMirrorOptions @currentDocument.toCodeMirrorOptions()

  syncEditorModeWithDocument: ()->
    if @currentDocument? && (@currentDocument.toMode() isnt @mode)
      @setMode @currentDocument.toMode()

  applyDocumentContentToPage: ()->
    @currentDocument?.loadInPage complete: ()=>
      if @currentDocument.type() is "script" or @currentDocument.type() is "template"
        CodeSync.onScriptChange?.call(window, @currentDocument.attributes)

      if @currentDocument.type() is "stylesheet"
        CodeSync.onStylesheetChange?.call(window, @currentDocument.attributes)

      @trigger "code:sync", @currentDocument
      @trigger "code:sync:#{ @currentDocument.type() }", @currentDocument, JST[@currentDocument.get('name')]

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
    if @position is "static"
      settings = {}

    if @position is "top"
      settings =
        top: '0px'

    if @position is "bottom"
      settings =
        bottom: '0px'
        height: '400px'

    settings

  hiddenStyleSettings: ()->
    if @position is "static"
      settings = {}

    if @position is "top"
      settings =
        top: ((@$el.height() + 8) * -1 ) + @hintHeight()
        bottom: 'auto'

    if @position is "bottom"
      settings =
        bottom: '0px'
        height: "#{ @hintHeight() - 8 }px"

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
      @$el.removeAttr('style').css('top','').css('bottom','')
      console.log "Vis Settings", @visibleStyleSettings()
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
CodeSync.commands =
  commandOne: ->
  commandTwo: ->
  commandThree: ->

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
