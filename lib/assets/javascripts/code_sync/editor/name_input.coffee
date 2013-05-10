CodeSync.NameInput = Backbone.View.extend
  className: "asset-name-input"

  events:
    "change input" : "updateEditor"
    "keyup input": "updateEditor"
    "blur input": "toggle"

  initialize: (options={})->
    @editor = options.editor

    _.bindAll(@,"_updateEditor","updateEditor","toggle")
    @_updateEditor = _.debounce(CodeSync.NameInput::_updateEditor, 300)

    Backbone.View::initialize.apply(@, arguments)

  render: ()->
    @$el.append("<input type='text' placeholder='Enter the name of the asset' />")
    @$el.hide()
    @

  updateEditor: ()->
    @_updateEditor()

  _updateEditor: ()->
    assetName = @$('input').val()

    if assetName.match(/\./)
      @editor.currentName = assetName

      if mode = @editor.determineModeFor(assetName)
        @editor.focus()

  setValue: (val)->
    @$('input').val value

  toggle: ()->
    @$el.toggle()
