CodeSync.AssetEditor = Backbone.View.extend
  visible: false

  initialize: (@options={})->
    _.extend(@, @options)

    @render()

  render: ()->
    return @ if @rendered is true

    @$el.append("<div class='codesync-editor-wrapper' />")
    @$('.codesync-editor-wrapper').append("<div class='codesync-asset-editor' />")
    $('body').append(@$el)

    @codeMirror = CodeMirror @$('.codesync-asset-editor')[0], @getCodeMirrorOptions()
    @codeMirror.swapDoc(@getCurrentDocument())

    @rendered = true
    @visible  = false

    @

  getCurrentDocument: ()->
    unless @document?
      @document = CodeMirror.Doc("","coffeescript", 0)

    @document

  hide: ()->
    @$el.hide()
    @visible = false
    @

  show: ()->
    @$el.show()
    @visible = true
    @

  toggle: ()->
    if @visible is false then @show() else @hide()

  getCodeMirrorOptions: ()->
    theme: 'lesser-dark'
    lineNumbers: true
    autofocus: true
    mode: "coffeescript"

CodeSync.AssetEditor.getInstance = (options={})->
  instances = CodeSync.AssetEditor._instances ||= {}
  instances.main ||= new CodeSync.AssetEditor(options)
