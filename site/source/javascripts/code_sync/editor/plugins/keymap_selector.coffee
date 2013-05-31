CodeSync.plugins.KeymapSelector = Backbone.View.extend
  className: "config-select keymap-selector"

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
    @editor.setKeymap(selected)

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

    for mode in ["vim","default"]
      options += "<option value='#{ mode }'>#{ mode }</option>"

    @$el.html("<label>Mode:</label> <select>#{ options }</select>")

    @hideLabel() unless @visibleLabel

    @


CodeSync.plugins.KeymapSelector.setup = (editor,options)->
  options.editor = editor

  @views.keymapSelector = new CodeSync.plugins.KeymapSelector(options)
  @views.keymapSelector.attach()
