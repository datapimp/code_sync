CodeSync.plugins.ModeSelector = Backbone.View.extend
  className: "mode-selector"

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

  render: ()->
    options = ""

    for mode in @modes.models
      options += "<option value='#{ mode.id }'>#{ mode.get('name') }</option>"

    @$el.html("<select>#{ options }</select>")

    @


CodeSync.plugins.ModeSelector.setup = (editor)->
  v = @views.modeSelector = new CodeSync.plugins.ModeSelector({editor})

  editor.$('.codesync-asset-editor').append v.render().el

  editor.on "document:loaded", (doc)->
    v.setValue(doc.get('mode'))


