CodeSync.ToolbarPanel = Backbone.View.extend
  buttonText: undefined
  buttonIcon: undefined

  className: "toolbar-panel"

  entranceEffect: "fadeIn"

  exitEffect: "fadeOut"

  toggle: ()->
    if @visible then @hide() else @show()

  show: ()->
    @$el.addClass("animated #{ @entranceEffect }")
    @

  hide: ()->
    @$el.addClass "animated #{ @exitEffect }"
    @

  render: ()->
    if @rendered is true
      @show()
      return @
    else
      @$el.html CodeSync.template("script_loader")
      @rendered = !! $(@renderTo).append(@el)
      @show()


original = CodeSync.ToolbarPanel.extend


CodeSync.ToolbarPanel.setup = (editor,options={})->
  {PluginClass} = options

  panel = new PluginClass(options)

  buttonElement = editor.addToolbarButton text: panel.buttonText, tooltip: panel.tooltip, icon: panel.buttonIcon

  buttonElement.on "click", panel.toggle, editor

  panel.renderTo = editor.$el
