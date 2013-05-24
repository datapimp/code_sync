CodeSync.plugins.ModeSelector = Backbone.View.extend
  className: "config-select mode-selector"

  events:
    "change select" : "onSelect"

  initialize: (options={})->
    _.extend(@, options)

    throw "Must supply an @editor instance" unless @editor

    @modes = @editor.modes

    @modes.on "reset", @render, @

    @editor.on "change:mode", (modeModel, modeId)=> @setValue(modeId)

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

  attach: ()->
    @render()
    $(@attachTo || @$(".toolbar-wrapper")).html(@el)

  render: ()->
    options = ""

    for mode in @modes.models when mode.isOfType(@showModes) is true
      options += "<option value='#{ mode.id }'>#{ mode.get('name') }</option>"

    @$el.html("<label>Language:</label> <select>#{ options }</select>")

    @hideLabel() unless @visibleLabel

    @


CodeSync.plugins.ModeSelector.setup = (editor,options)->
  options.editor = editor

  @views.modeSelector = new CodeSync.plugins.ModeSelector(options)
  @views.modeSelector.attach()
