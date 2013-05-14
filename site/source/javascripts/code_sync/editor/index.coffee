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

  editorChangeThrottle: 1200

  visible: false

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

  getCodeMirrorOptions: ()->
    theme: 'lesser-dark'
    lineNumbers: true
    autofocus: true
    mode: CodeSync.AssetEditor.guessModeFor(@defaultExtension)
    extraKeys:
      "Ctrl-S": ()=>
        @documentManager.saveCurrentDocument()

      "Ctrl-N": ()=>
        @documentManager.newDocument()

      "Ctrl-J": ()=>
        @toggle()

      "Ctrl-T": ()=>
        @documentManager.toggleAssetSelector()

  editorChangeHandler: (editorContents)->
    documentModel = @views.documentManager.getCurrentDocument()
    documentModel.set("contents", editorContents)

  render: ()->
    return @ if @rendered is true

    @$el.html JST["code_sync/editor/templates/asset_editor"]()

    @views.documentManager = new CodeSync.DocumentManager(editor: @)

    @on "codemirror:setup", ()=>
      @$el.append @views.documentManager.render().el

    @rendered = true

    @

  showStatusMessage:(options={})->
    @$('.status-message').remove()
    @$el.prepend "<div class='status-message #{ options.type }'>#{ options.message }</div>"

    if options.type is "success"
      _.delay ()=>
        @$('.status-message').fadeOut()
      , @effectDuration

  effectSettings: ()->
    switch @effect

      when "slide"
        if @visible is true and @position is "top"
          top: "#{ ((@height + 5) * -1) }px"
        else
          top: "0px"

      when "fade"
        if @visible is true
          opacity: 0
        else
          opacity: 0.98


  hide: (withEffect=true)->
    @animating = true

    completeFn = _.debounce ()=>
      @visible = false
      @animating = false
      @$el.hide()
    , @effectDuration + 20

    if withEffect is true
      @$el.animate @effectSettings(), duration: @effectDuration, complete: completeFn
      _.delay(completeFn, @effectDuration)
    else
      completeFn()

    @

  show: (withEffect=true)->
    @setupCodeMirror()

    @$el.show()
    @animating = true

    completeFn = _.debounce ()=>
      window.scrollTo(0,0)
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
