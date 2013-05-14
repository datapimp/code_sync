CodeSync.ModeSelector = Backbone.View.extend
  className: "mode-selector"

  initialize: ()->
    @collection = CodeSync.Modes.get()
    @collection.on "reset", @render, @

    @$el.append "<select />"

  render: ()->
    select = @$('select')

    @collection.each (model)=>
      select.append "<option value='#{ model.get('codeMirrorMode') }>#{ model.get('name') }</option>"

    @


