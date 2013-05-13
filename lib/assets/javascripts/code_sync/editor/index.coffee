#= require keylauncher
#= require ./templates
#= require_tree ./datasources
#= require_tree ./views
#= require_self

CodeSync.AssetEditor = Backbone.View.extend

  className: "codesync-editor"

  renderVisible: true

  autoRender: true

  defaultExtension: ".coffee"

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

    @assetCompilationEndpoint = CodeSync.get("assetCompilationEndpoint")

    @assetsCollection = new CodeSync.ProjectAssets()

    #if client = CodeSync.Client.get()
    #  client.onNotification = (notification)=>
    #    console.log "Editor trapping notification", @currentPath, notification

    @$el.addClass "#{ @position }-positioned"

    @render() unless @autoRender is false

    @on "editor:change", _.debounce(@editorChangeHandler, 1200), @

  editorChangeHandler: ()->
    return if @currentPath?

    if !@currentName? || @currentName?.length is 0 && @defaultExtension?
      @compileEditorContentsAndReload()

  processStyleContent: (content)->
    $('head style[data-ad-hoc]').remove()
    $('head').append "<style type='text/css' data-ad-hoc=true>#{ content }</style>"

  processScriptContent: (code)->
    evalRunner = (code)-> eval(code)
    evalRunner.call(window, code)

  compileEditorContentsAndReload: ()->
    handler = switch @codeMirror.getOption('mode')
      when "css","sass","scss"
        @processStyleContent
      when "coffeescript","javascript","skim","haml","jst"
        @processScriptContent

    $.ajax
      type: "POST"
      url: @assetCompilationEndpoint

      data: JSON.stringify
        name: (@currentName || "adhoc").replace(@defaultExtension,'')
        extension: @defaultExtension
        contents: @codeMirror.getValue()

      success: (response)=>
        if response.success is false and response.error?
          @showStatusMessage(type:"error",message:response.error.message)

        if response.success is true && (response.compiled? && handler)
          @$('.status-message').remove()
          handler(response.compiled)

  render: ()->
    return @ if @rendered is true

    $('body').append(@$el)

    @$el.html JST["code_sync/templates/asset_editor"]()

    unless @simpleMode is true
      @views.nameInput = new CodeSync.NameInput(editor: @)
      @views.preferencesPanel = new CodeSync.PreferencesPanel(editor:@)

      @$('.asset-save-controls').before( @views.nameInput.render().el )
      @$el.append( @views.preferencesPanel.render().el )

    unless @useDocumentManager is false
      @views.documentManager = new CodeSync.DocumentManager(editor: @)
      @$el.append( @views.documentManager.render().el )


    @rendered = true
    @visible  = false

    @show()

    @$el.css('top':"#{ -1 * @height }px")
    @height ||= @$el.height()

    @$('.keyboard-shortcut-info').html CodeSync.AssetEditor.keyboardShortcutInfo

    @

  saveAsset: ()->
    if !@currentPath && !@currentName?
      @toggleNameInput()
      return

    [name,rest...] = (@currentPath || @currentName).split('.')
    extension = rest.join('.')

    $.ajax
      type: "POST"
      url: @assetCompilationEndpoint

      success: (response)=>
        if response.success is false
          @showStatusMessage(type:"error",message:response.error?.message)
        else if response.success is true && response.compiled?
          @showStatusMessage(type:"success",message:"Successfully saved #{ @currentPath }")

      data: JSON.stringify
        contents: @codeMirror.getValue()
        path: @currentPath
        name: (if !@currentPath? && @currentName? then name else @currentName)
        extension: ".#{extension}"

  loadAsset: (@currentPath)->
    $.ajax
      type: "GET"
      url: "#{ CodeSync.get("assetCompilationEndpoint") }?path=#{ @currentPath }"
      success: (response)=>

        @views.nameInput.setValue(@currentPath)

        if response.path?
          @determineModeFor(response.path)

        if response.contents?
          @codeMirror.setValue(response.contents)

  showStatusMessage:(options={})->
    @$('.status-message').remove()
    @$el.prepend "<div class='status-message #{ options.type }'>#{ options.message }</div>"

    if options.type is "success"
      _.delay ()=>
        @$('.status-message').fadeOut()
      , 400

  getCurrentDocument: ()->
    unless @document?
      @document = CodeMirror.Doc(CodeSync.AssetEditor.helpText,"coffeescript", 0)

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
    mode: "coffeescript"
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

    @setMode(mode)
    @views.preferencesPanel.syncWithEditorOptions()

  setDefaultExtension: ()->
    @defaultExtension = switch @codeMirror.getOption('mode')
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
CodeSync.AssetEditor.helpText = """
# Welcome to the CodeSync Asset Editor
#
# This editor allows you to edit compiled asset pipeline assets in
# your project.  It supports most of the languages we love, such as
# coffeescript, sass, skim and jst for client side templating.
#
# Try it out now.  Uncomment the following line:
#
# window.location = 'http://twitter.com/soederpop'
#
# You can switch languages using preferences, or intelligently by filename.
#
# Keyboard Shortcuts:
#
# Ctrl + J -- Toggle the editor
# Ctrl + N -- New Asset
# Ctrl + T -- Find Asset
# Ctrl + S -- Save Asset
"""

CodeSync.AssetEditor.keyboardShortcutInfo = """
ctrl+j: toggle editor ctrl+t: open asset
"""

CodeSync.AssetEditor.toggleEditor = (options={})->
  if window.codeSyncEditor?
    window.codeSyncEditor.slideToggle()
  else
    window.codeSyncEditor = new CodeSync.AssetEditor(options)
    window.codeSyncEditor.slideIn()

CodeSync.AssetEditor.setHotKey = (hotKey, options={})->
  key(hotKey, ()-> CodeSync.AssetEditor.toggleEditor(options))
