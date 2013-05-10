#= require keylauncher
#= require_tree .
#= require_self

CodeSync.AssetEditor = Backbone.View.extend

  className: "codesync-editor"

  renderVisible: true

  autoRender: true

  assetCompilationEndpoint: "http://localhost:9295/source"

  events:
    "click .asset-save-controls .save-button" : "saveAsset"
    "click .asset-save-controls .open-button" : "toggleAssetSelector"
    "click .toggle-preferences"               : "togglePreferencesPanel"

  initialize: (@options={})->
    _.extend(@, @options)

    @assetsCollection = new CodeSync.ProjectAssets()

    client = CodeSync.Client.get()

    client.onNotification = (notification)=>
      console.log "Editor trapping notification", @currentPath, notification

    @render() unless @autoRender is false

  render: ()->
    return @ if @rendered is true

    $('body').append(@$el)

    @$el.html JST["code_sync/templates/asset_editor"]()

    @_nameInput = new CodeSync.NameInput(editor: @)
    @_preferencesPanel = new CodeSync.PreferencesPanel(editor:@)

    @$('.asset-save-controls').before( @_nameInput.render().el )
    @$el.append( @_preferencesPanel.render().el )

    @rendered = true
    @visible  = false

    @show()

    @$el.css('top':"#{ -1 * @height }px")
    @height ||= @$el.height()

    @

  processCompiledResponse:(content,name,extension)->
    console.log "Processing Compiled Response", arguments

  saveAsset: ()->
    if !@currentPath && !@currentName?
      @toggleNameInput()
      return

    [name,rest...] = (@currentPath || @currentName).split('.')
    extension = rest.join('.')

    $.ajax
      type: "POST"
      url: @assetCompilationEndpoint

      error: (response)=>
        console.log "Error Response", arguments

      success: (response)=>
        if response.success && response.compiled?
          @processCompiledResponse(response.compiled, extension, name)

      data: JSON.stringify
        contents: @codeMirror.getValue()
        path: @currentPath
        name: (if !@currentPath? && @currentName? then name else @currentName)
        extension: ".#{extension}"

  loadAsset: (@currentPath)->
    $.ajax
      type: "GET"
      url: "http://localhost:9295/source?path=#{ @currentPath }"
      success: (response)=>

        @_nameInput.setValue(@currentPath)

        if response.path?
          @determineModeFor(response.path)

        if response.contents?
          @codeMirror.setValue(response.contents)


  getCurrentDocument: ()->
    unless @document?
      @document = CodeMirror.Doc("","coffeescript", 0)

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

    @

  slideToggle: ()->
    top = @$el.css('top')
    if top is "0px" then @slideOut() else @slideIn()

  toggleNameInput: ()->
    @_nameInput?.toggle()

  toggleAssetSelector: ()->
    if !@_assetSelector
      @_assetSelector = new CodeSync.AssetSelector(editor: @)
      @$el.prepend(@_assetSelector.render().el)

    @_assetSelector.toggle()

  togglePreferencesPanel: ()->
    @_preferencesPanel?.toggle()

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
        @_nameInput.$('input').focus()

      "Ctrl-J": ()=>
        @slideToggle()

      "Ctrl-T": ()=>
        @toggleAssetSelector()

  determineModeFor: (path)->
    mode = if path.match(/\.coffee/)
      "coffeescript"
    else if path.match(/\.js$/)
      "javascript"
    else if path.match(/\.css$/)
      "css"
    else if path.match(/.rb$/)
      "ruby"
    else if path.match(/.html$/)
      "htmlmixed"
    else if path.match(/.less/)
      "less"
    else if path.match(/\.skim/)
      "skim"
    else if path.match(/\.haml/)
      "haml"
    else if path.match(/\.sass/)
      "sass"
    else if path.match(/\.scss/)
      "css"

    @codeMirror.setOption 'mode', mode
    @_preferencesPanel.syncWithEditorOptions()


# Private Helpers

toggleEditor = ()->
  if window.codeSyncEditor?
    window.codeSyncEditor.slideToggle()
  else
    window.codeSyncEditor = new CodeSync.AssetEditor()
    window.codeSyncEditor.slideIn()

key('ctrl+j', toggleEditor)