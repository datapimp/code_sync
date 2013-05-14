CodeSync.plugins.ModeSelector = Backbone.View.extend
  className: "mode-selector"

  events:
    "change select" : "onSelect"

  initialize: (options={})->
    @modes = CodeSync.Modes.get()
    @modes.on "reset", @render, @

    @editor = options.editor

    Backbone.View::initialize.apply(@, arguments)

  onSelect: ()->
    selected = @$('select').val()
    mode = @modes.get(selected)

    @editor.setMode(mode)

  setValue: (val)->
    @$('select').val(val)

  render: ()->
    options = ""

    for mode in @modes.models
      options += "<option value='#{ mode.id }'>#{ mode.get('name') }</option>"

    @$el.html("<select>#{ options }</select>")

    @


CodeSync.plugins.ModeSelector.setup = (editor)->
  v = @views.modeSelector = new CodeSync.plugins.ModeSelector({editor})

  editor.$el.append v.render().el

  editor.on "document:loaded", (doc)->
    v.setValue(doc.get('mode'))


