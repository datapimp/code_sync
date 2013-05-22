CodeSync.plugins.KeymapSelector = Backbone.View.extend
  className: "config-select keymap-selector"

  events:
    "change select" : "onSelect"

  initialize: (options={})->
    @editor = options.editor

    @editor.on "change:keymap",  (keyMap)=>
      @setValue(keyMap)

    Backbone.View::initialize.apply(@, arguments)

  onSelect: ()->
    selected = @$('select').val()
    @editor.setKeyMap(selected)

  setValue: (val)->
    @$('select').val(val)

  render: ()->
    options = ""

    for mode in ["default","vim"]
      options += "<option value='#{ mode }'>#{ mode }</option>"

    @$el.html("<label>Keymap</label> <select>#{ options }</select>")

    @


CodeSync.plugins.KeymapSelector.setup = (editor)->
  v = @views.keymapSelector = new CodeSync.plugins.KeymapSelector({editor})
  @$('.toolbar-wrapper').append( v.render().el )

