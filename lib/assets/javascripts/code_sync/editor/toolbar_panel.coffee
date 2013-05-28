CodeSync.ToolbarPanel = Backbone.View.extend
  buttonText: undefined

  buttonIcon: undefined

  entranceEffect: "bounceInDown"

  exitEffect: "bounceOutUp"

  visible: false

  panelTemplate: "toolbar_panel"

  availableInModes: "all"

  initialize: (@options)->
    _.extend(@, @options)

    Backbone.View::initialize.apply(@, arguments)

    @editor.on "change:mode", @checkAvailabilityInMode, @
    @editor.on "document:loaded", @checkAvailabilityInMode, @

  checkAvailabilityInMode: ()->
    return @buttonElement.show() if (@availableInModes is "all" or !@availableInModes?)

    type = @editor.mode?.type?() || @editor.currentDocument.type()
    if type is @availableInModes
      @buttonElement.show()
    else
      @buttonElement.hide()

  toggle: ()->
    if @$el.attr('data-removed') is true
      @visible = true
      @$el.removeAttr('data-removed')

    if @visible then @hide() else @show()

  show: ()->
    @removeOtherToolbarPanels()
    @render()
    @$el.removeClass(@exitEffect)
    @$el.addClass("animated #{ @entranceEffect }")
    @visible = true
    @

  hide: ()->
    @$el.removeClass(@entranceEffect)
    @$el.addClass("animated #{ @exitEffect }")
    @visible = false
    @

  removeOtherToolbarPanels: ()->
    $(@renderTo).find('.toolbar-panel').addClass('animated #{ @exitEffect }').attr('data-removed',true)

  render: ()->
    if @rendered is true
      return @
    else
      @beforeRender?()
      @$el.addClass("toolbar-panel")
      @$el.html CodeSync.template(@panelTemplate)
      @rendered = !! $(@renderTo).append(@el)
      @afterRender?()
      @checkAvailabilityInMode()
      return @

original = CodeSync.ToolbarPanel.extend


CodeSync.ToolbarPanel.setup = (editor,options={})->
  {PluginClass} = options

  options.editor = editor

  panel = new PluginClass(options)

  panel.buttonElement = editor.addToolbarButton panel: panel.className, text: panel.buttonText, tooltip: panel.tooltip, icon: panel.buttonIcon

  panel.buttonElement.on "click", (e)=> panel.toggle()

  panel.renderTo = editor.$el
