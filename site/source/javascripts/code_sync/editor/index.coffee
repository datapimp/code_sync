#= require skim
#= require_tree ./templates
#= require_tree ./datasources
#= require_tree ./views
#= require_self

CodeSync.AssetEditor = Backbone.View.extend

  className: "codesync-editor"

  renderVisible: true

  autoRender: true

  position: "top"

  useDocumentManager: true

  simpleMode: false

  views: {}

  events:
    "click .asset-save-controls .save-button" : "saveAsset"
    "click .asset-save-controls .open-button" : "toggleAssetSelector"
    "click .toggle-preferences"               : "togglePreferencesPanel"

  initialize: (@options={})->
    _.extend(@, @options)

    @$el.addClass "#{ @position }-positioned"

    @defaultFileType = @defaultFileType || CodeSync.get("defaultFileType")
    @defaultExtension = @defaultExtension || @setDefaultExtension(@defaultFileType)

    @assetCompilationEndpoint = CodeSync.get("assetCompilationEndpoint")

    #if client = CodeSync.Client.get()
    #  client.onNotification = (notification)=>
    #    console.log "Editor trapping notification", @currentPath, notification


    @render() unless @autoRender is false

    @on "editor:change", _.debounce(@editorChangeHandler, 1200), @

  editorChangeHandler: ()->

  render: ()->
    return @ if @rendered is true

    @rendered = true
    @visible  = false

    @show()

    @

  showStatusMessage:(options={})->
    @$('.status-message').remove()
    @$el.prepend "<div class='status-message #{ options.type }'>#{ options.message }</div>"

    if options.type is "success"
      _.delay ()=>
        @$('.status-message').fadeOut()
      , 400

  getCurrentDocument: ()->
    unless @document?
      @document = CodeMirror.Doc("", @defaultFileType, 0)

    @document

  hide: ()->
    @$el.hide()
    @

  slideOut: ()->
    @$el.animate {top: "#{ (-1 * @height) - 10  }px"}, duration: 400

  slideIn: ()->
    @$el.animate {top: "0px"}, duration: 400

  show: ()->
    @$el.show()
    @setupCodeMirror()
    window.scrollTo(0,0)
    @

  toggle: ()->
    if @$el.is(':visible') then @hide() else @show()

  setupCodeMirror: _.once ()->
    @height ||= @$el.height()
    @codeMirror = CodeMirror @$('.codesync-asset-editor')[0], @getCodeMirrorOptions()
    @codeMirror.swapDoc(@getCurrentDocument())

    changeHandler = (changeObj)=>
      @trigger "editor:change", @codeMirror.getValue(), changeObj

    @codeMirror.on "change", _.debounce(changeHandler, 800)

    @codeMirror.on "focus", ()=> @views.preferencesPanel.$el.hide()

    @

  slideToggle: ()->
    top = @$el.css('top')
    if top is "0px" then @slideOut() else @slideIn()

  toggleNameInput: ()->
    @views.nameInput?.toggle()

  toggleAssetSelector: ()->
    if !@_assetSelector
      @_assetSelector = new CodeSync.AssetSelector(editor: @)
      @$el.prepend(@_assetSelector.render().el)

    @_assetSelector.toggle()

  togglePreferencesPanel: ()->
    @views.preferencesPanel?.toggle()

  getCodeMirrorOptions: ()->
    theme: 'lesser-dark'
    lineNumbers: true
    autofocus: true
    mode: CodeSync.AssetEditor.guessModeFor(@defaultExtension)
    extraKeys:
      "Ctrl-S": ()=>
        @saveAsset()

      "Ctrl-N": ()=>
        @currentPath = @currentName = undefined
        @toggleNameInput()
        @views.nameInput.$('input').focus()

      "Ctrl-J": ()=>
        @slideToggle()

      "Ctrl-T": ()=>
        @toggleAssetSelector()

  determineModeFor: (path)->
    mode = CodeSync.AssetEditor.guessModeFor(path)
    @setMode(mode)
    @views.preferencesPanel.syncWithEditorOptions()

  setDefaultExtension: (mode)->
    CodeSync.AssetEditor.guessExtensionFor(mode || @codeMirror?.getOption('mode'))
    @

  setKeyMap: (keyMap)->
    @codeMirror.setOption 'keyMap', keyMap

  setTheme: (theme)->
    @codeMirror.setOption 'theme', theme

  setMode: (mode)->
    @codeMirror.setOption 'mode', mode
    @setDefaultExtension()
    @


# Private Helpers

CodeSync.AssetEditor.keyboardShortcutInfo = """
ctrl+j: toggle editor ctrl+t: open asset
"""

CodeSync.AssetEditor.guessExtensionFor = (mode)->
  switch mode
    when "skim"
      ".jst.skim"
    when "markdown"
      ".jst.md"
    when "haml"
      ".jst.haml"
    when "css"
      ".css.scss"
    when "sass"
      ".css.sass"
    when "coffeescript"
      ".coffee"
    when "javascript"
      ".js"
    when "ruby"
      ".rb"
    else
      ".coffee"

CodeSync.AssetEditor.guessModeFor = (path)->
  path = ".#{ path }"

  mode = if path.match(/\.coffee/)
    "coffeescript"
  else if path.match(/\.js$/)
    "javascript"
  else if path.match(/\.md$/)
    "markdown"
  else if path.match(/\.css$/)
    "css"
  else if path.match(/\.rb$/)
    "ruby"
  else if path.match(/\.html$/)
    "htmlmixed"
  else if path.match(/\.less/)
    "less"
  else if path.match(/\.skim/)
    "skim"
  else if path.match(/\.haml/)
    "haml"
  else if path.match(/\.sass/)
    "sass"
  else if path.match(/\.scss/)
    "css"

CodeSync.AssetEditor.toggleEditor = (options={})->
  if window.codeSyncEditor?
    window.codeSyncEditor.slideToggle()
  else
    window.codeSyncEditor = new CodeSync.AssetEditor(options)
    window.codeSyncEditor.slideIn()

CodeSync.AssetEditor.setHotKey = (hotKey, options={})->
  key(hotKey, ()-> CodeSync.AssetEditor.toggleEditor(options))
