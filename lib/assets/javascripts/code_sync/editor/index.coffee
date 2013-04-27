#= require ./dependencies
#= require_tree .
#= require_self

CodeSync.AssetEditor = Backbone.View.extend

  className: "codesync-editor"

  renderVisible: true

  autoRender: true

  events:
    "click .asset-save-controls .save-button" : "saveAsset"
    "click .asset-save-controls .open-button" : "toggleAssetSelector"

  initialize: (@options={})->
    _.extend(@, @options)

    @assetsCollection = new CodeSync.ProjectAssets()

    @render() unless @autoRender is false

  render: ()->
    return @ if @rendered is true

    $('body').append(@$el)

    @$el.html JST["code_sync/templates/asset_editor"]()

    @rendered = true
    @visible  = false

    @show()

    @$el.css('top':"#{ -1 * @height }px")
    @height ||= @$el.height()

    @

  saveAsset: ()->
    if @currentPath? and contents = @codeMirror.getValue()
      $.ajax
        type: "POST"
        url: "http://localhost:9295/source"
        data:
          path: @currentPath
          contents: contents

  loadAsset: (@currentPath)->
    $.ajax
      type: "GET"
      url: "http://localhost:9295/source?path=#{ @currentPath }"
      success: (response)=>

        if response.path?
          @codeMirror.setOption 'mode', determineModeFor(response.path)

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
    @

  toggle: ()->
    if @$el.is(':visible') then @hide() else @show()

  setupCodeMirror: _.once ()->
    @height ||= @$el.height()
    @codeMirror = CodeMirror @$('.codesync-asset-editor')[0], @getCodeMirrorOptions()
    @codeMirror.swapDoc(@getCurrentDocument())

  slideToggle: ()->
    top = @$el.css('top')
    if top is "0px" then @slideOut() else @slideIn()

  toggleAssetSelector: ()->
    if !@_assetSelector
      @_assetSelector = new CodeSync.AssetSelector(editor: @)
      @$el.prepend(@_assetSelector.render().el)

    @_assetSelector.toggle()

  getCodeMirrorOptions: ()->
    theme: 'lesser-dark'
    lineNumbers: true
    autofocus: true
    mode: "coffeescript"
    extraKeys:
      "Ctrl-S": ()=>
        @saveAsset()

      "Ctrl-J": ()=>
        @slideToggle()

      "Ctrl-T": ()=>
        @toggleAssetSelector()


key 'ctrl+j', _.debounce ()->
  if window.codeSyncEditor?
    window.codeSyncEditor.slideToggle()
  else
    window.codeSyncEditor = new CodeSync.AssetEditor()
    window.codeSyncEditor.slideIn()
, 500


determineModeFor = (path)->
  if path.match(/\.coffee/)
    "coffeescript"
  else if path.match(/\.scss/)
    "css"
