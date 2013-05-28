
CodeSync.AssetEditor = Backbone.View.extend
  name: "code_sync"
  className: "codesync-editor"

  height: 400

  # Valid options are top, bottom, static
  position: "top"

  # Controls whether or not a toolbar element
  # should be displayed.  Certain plugins will
  # render their buttons etc in the toolbar
  enableToolbar: true

  # Valid options are: true, "all", "success", "error"
  enableStatusMessages: true

  autoRender: true
  autoAppend: true
  appendTo: "body"

  renderVisible: true

  effect: "slide"
  effectDuration: 400

  editorChangeThrottle: 400

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
    "DocumentTabs"
  ]

  pluginOptions: {}

  views: {}

  initialize: (@options={})->
    _.extend(@, @options)

    Backbone.View::initialize.apply(@, arguments)

    CodeSync.AssetEditor.instances[@name || @cid] = @

    _.bindAll(@, "editorChangeHandler")

    @modes            = CodeSync.Modes.get()
    @documentManager  = new CodeSync.DocumentManager(editor: @)

    @startMode        = @modes.get(@startMode) || CodeSync.Modes.defaultMode()

    @on "editor:change", _.debounce(@editorChangeHandler, @editorChangeThrottle), @

    @on "codemirror:setup", ()=> @loadDefaultDocument()

    @$el.append "<div class='toolbar-wrapper' />"
    @$el.append "<div class='codemirror-wrapper' />"
    @setupToolbar()

    @$el.attr('data-codesync', @name) if @name?


    @loadPlugins()

    @setHeight(@height, false)
    @setPosition(@position, false)

    @render() unless @autoRender is false

  addPlugin: (plugin)->
    CodeSync.plugins[plugin]?.setup.call(@,@)

  loadPlugins: ()->
    for plugin in @plugins when CodeSync.plugins[plugin]?
      options = @pluginOptions[plugin] || {}
      PluginClass = CodeSync.plugins[plugin]

      options.PluginClass = PluginClass
      PluginClass.setup.call(@,@,options)

  render: ()->
    return @ if @rendered is true

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
    @codeMirror = CodeMirror(@$('.codemirror-wrapper')[0], @getCodeMirrorOptions())

    @on "initial:document:load", ()=>
      if @startMode
        @setMode(@startMode)

      if @keyBindings
        @setKeyMap(@keyBindings)

      if @theme ||= localStorage.getItem("codesync:theme")
        @setTheme(@theme)



    @codeMirror.on "change", _.debounce(((changeObj)=> @trigger "editor:change", @codeMirror.getValue(), changeObj), @editorChangeThrottle)

    @trigger "codemirror:setup", @codeMirror

    @

  codeMirrorKeyBindings:
    "Ctrl+Command+1": ()->
      CodeSync.get("commandOne")?.call?(@)

    "Ctrl+Command+2": ()->
      CodeSync.get("commandTwo")?.call?(@)

    "Ctrl+Command+3": ()->
      CodeSync.get("commandThree")?.call(@)

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

  setHeight: (@height, show=true)->
    if _.isNumber(@height)
      @height = "#{ @height }px"

    @$el.css('height', @height)
    @$el.addClass('static-height')

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

    if @mode? and (newMode isnt @mode)
      @trigger "change:mode", newMode, newMode.id
      @onModeChange?.call(@,newMode,@mode)

    @mode = newMode

    @$el.attr("data-codesync-mode", @mode.id)

    if @mode?.get?
      @codeMirror.setOption 'mode', @mode.get("codeMirrorMode")
      @currentDocument.set('mode', @mode.id)
      @currentDocument.set('extension', CodeSync.Modes.guessExtensionFor(@mode.id) )

    @

  setCodeMirrorOptions: (options={})->
    for option,value of options
      @codeMirror.setOption(option,value)

  addToolbarButton: (options={})->
    el = $(CodeSync.template("toolbar_button", options))
    @$('.toolbar-wrapper').append(el)
    el

  setupToolbar: ()->
    @$('.toolbar-wrapper').hide() unless @enableToolbar

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
    @documentManager.openDocument(@getDefaultDocument(), @)

  loadDocument: (doc)->
    if current = @currentDocument
      current.off "status", @showStatusMessage
      current.off "change:compiled", @applyDocumentContentToPage
      current.off "change:mode", @applyDocumentContentToPage, @

      @previousDocument = current
    else
      @trigger "initial:document:load", @currentDocument = doc

    doc.on "status", @showStatusMessage, @
    doc.on "change:compiled", @applyDocumentContentToPage, @
    doc.on "change:mode", @syncEditorModeWithDocument, @

    @codeMirror.swapDoc doc.toCodeMirrorDocument()
    @trigger "document:loaded", doc, @previousDocument

    @setCodeMirrorOptions doc.toCodeMirrorOptions()

    @currentDocument = doc

  syncEditorModeWithDocument: ()->
    if @currentDocument? && (@currentDocument.toMode() isnt @mode)
      @setMode @currentDocument.toMode()

  applyDocumentContentToPage: ()->
    doc = @currentDocument
    @currentDocument?.loadInPage complete: ()=>
      @trigger "code:sync:#{ doc.type() }", doc

  removeStatusMessages: ()->
    @$('.status-message').remove()

  showError: (message)->
    @showStatusMessage type:"error", message: message

  showStatusMessage:(options={})->
    @removeStatusMessages()

    allowedTypes = switch @enableStatusMessages
      when false
        []
      when true, "all"
        ["success","error","notice"]
      else
        [@enableStatusMessages]

    return unless _(allowedTypes).indexOf(options.type) >= 0

    if options.message?.length > 0
      @$el.prepend "<div class='status-message #{ options.type }'>#{ options.message }</div>"

    if options.type is "success"
      _.delay ()=>
        @$('.status-message.success').animate({opacity:0}, duration: 400, complete: ()=> @$('.status-message.success').remove())
      , 1200

  hintHeight: ()->
    offset = if @showVisibleTab then @$('.document-tabs').height() else 0

  visibleStyleSettings: ()->
    if @position is "static"
      settings = {}

    if @position is "top"
      settings =
        top: '0px'

    if @position is "bottom"
      settings =
        bottom: '0px'
        height: @height

    settings

  hiddenStyleSettings: ()->
    if @position is "static"
      settings = {}

    if @position is "top"
      settings =
        top: @$('.codemirror-wrapper').height() * -1
        bottom: 'auto'

    if @position is "bottom"
      settings =
        bottom: '0px'
        height: @height - @$('.document-tabs').height()

    settings

  hide: (withEffect=true)->
    console.trace()

    @animating = true

    view.trigger("editor:hidden") for viewName, view of @views
    @$el.removeAttr('data-visible') if @hideable

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
    @$el.attr('data-visible',true) if @hideable

    completeFn = _.debounce ()=>
      @visible = true
      @animating = false
    , @effectDuration

    if withEffect isnt false
      @$el.removeAttr('style').css('top','').css('bottom','')
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

CodeSync.AssetEditor.instances = {}

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
