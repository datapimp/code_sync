CodeSync.plugins.ColorPicker = Backbone.View.extend
  className: "codesync-color-picker"

  spectrumOptions:
    showAlpha: true
    preferredFormat: "hex6"
    flat: true
    showInput: true
    chooseText: "Choose"

  initialize: (@options={})->
    _.extend(@,@options)

    @$el.append "<input type='color' class='color-picker-widget' />"

    @widget = @$('.color-picker-widget')

  remove: ()->
    @widget.spectrum("destroy")
    @$el.remove()

  hide: ()->
    @widget.spectrum("hide")
    @$el.hide()

  show: ()->
    @widget.spectrum("show")
    @$el.show()

  render: ()->
    @widget.spectrum(@spectrumOptions)

    @