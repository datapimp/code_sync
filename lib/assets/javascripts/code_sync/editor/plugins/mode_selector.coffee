CodeSync.plugins.ModeSelector = Backbone.View.extend
  className: "config-select mode-selector"

  events:
    "change select" : "onSelect"

  initialize: (options={})->
    @editor = options.editor

    @modes = @editor.modes

    @modes.on "reset", @render, @

    @editor.on "change:mode", (modeModel, modeId)=>
      @setValue(modeId)

    Backbone.View::initialize.apply(@, arguments)

  onSelect: ()->
    selected = @$('select').val()
    mode = @modes.get(selected)

    @editor.setMode(mode)

  setValue: (val)->
    @$('select').val(val)

  hideLabel: ()->
    @$('label').hide()

  showLabel: ()->
    @$('label').show()

  render: ()->
    options = ""

    for mode in @modes.models
      options += "<option value='#{ mode.id }'>#{ mode.get('name') }</option>"

    @$el.html("<label>Language:</label> <select>#{ options }</select>")

    @hideLabel() unless @visibleLabel

    @


CodeSync.plugins.ModeSelector.setup = (editor)->
  v = @views.modeSelector = new CodeSync.plugins.ModeSelector({editor})
  @$('.toolbar-wrapper').append v.render().el

  editor.on "document:loaded", (doc)-> v.setValue(doc.get('mode'))


