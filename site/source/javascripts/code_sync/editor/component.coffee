CodeSync.EditorComponent = Backbone.View.extend
  name: "code_sync"

  className: "codesync-editor-component"

  # Valid options are: true, "all", "success", "error"
  enableStatusMessages: true

  startMode: "scss"
  theme: "ambiance"

  keyBindings: ""

  events:
    "click .status-message" : "removeStatusMessages"

  liveMode: true

  initialize: (@options={})->
    _.extend(@, @options)

    @views = {}

    Backbone.View::initialize.apply(@, arguments)

    _.bindAll(@, "editorChangeHandler")

    @modes            = CodeSync.Modes.get()
    @documentManager  = @options.documentManager || new CodeSync.DocumentManager(editor: @)

    @startMode        = @modes.get(@startMode) || CodeSync.Modes.defaultMode()

    @on "codemirror:setup", ()=>
      @loadDefaultDocument()

    @enableLiveMode() if @liveMode is true

    @render() unless @autoRender is false

  enableLiveMode: (throttle)->
    @liveModeHandler = _.debounce(@editorChangeHandler, throttle || @editorChangeThrottle)
    @on "editor:change", @liveModeHandler, @

  disableLiveMode: ()->
    @off "editor:change", @liveModeHandler

  render: ()->
    @setupCodeMirror()
    @

  setupCodeMirror: ()->
    return if @codeMirror?

    @$el.append "<div class='codemirror-wrapper' />"

    console.log(@$('.codemirror-wrapper')[0])
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
    @currentDocument.set("contents", editorContents, liveMode: @liveMode)

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

  getDefaultDocument: ()->
    defaultOptions =
      mode: @options.startMode || CodeSync.get("defaultFileType")
      sticky: true
      doNotSave: true
      name: @defaultDocumentName || "codesync"
      display: "CodeSync"
      content: ("hahahahha\n" for n in [1,2,3,4,5,6,6])

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

CodeSync.EditorComponent.instances = {}

# Private Helpers
CodeSync.commands =
  commandOne: ->
  commandTwo: ->
  commandThree: ->
