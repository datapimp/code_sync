CodeSync.ToolbarPanel = Backbone.View.extend
  buttonText: undefined

  buttonIcon: undefined

  buttonTemplate: "toolbar_button"

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
    # if the DOM element was removed
    # that means another panel was displayed
    # so we need to sync up w what our state should be
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
    $(@renderTo()).find('.toolbar-panel').addClass("animated #{ @exitEffect }").attr('data-removed',true)

  templateOptions: ->
    @options

  setupButtonElement: ()->
    return @buttonElement if @buttonElement

    wrapper               = @editor.toolbarWrapperElement()
    html                  = $(CodeSync.template(@buttonTemplate, name: @name, icon: @buttonIcon, text: @buttonText))

    wrapper.append(html)
    @buttonElement = wrapper.find("[data-editor='#{ @name }']").eq(0)

    @buttonElement.on "click", ()=> @toggle()

    @buttonElement

  render: () ->
    if @rendered is true
      return @
    else
      return @ if @beforeRender?() is false

      @$el.addClass("toolbar-panel")
      @$el.append CodeSync.template(@panelTemplate, @templateOptions())
      $(@renderTo()).append(@el)

      @afterRender?()
      @rendered = true
      @checkAvailabilityInMode()
      return @

original = CodeSync.ToolbarPanel.extend


CodeSync.ToolbarPanel.setup = (editor,options={})->
  {PluginClass} = options

  options.editor = editor

  editor.views ||= {}

  panel = new PluginClass(options)

  if panel.handle
    editor.views[panel.handle] = panel

  panel.setupButtonElement()

  panel.renderTo = ()-> editor.$('.codemirror-wrapper')

  editor.on "codemirror:setup", (cm)->
    cm.on "focus", ()-> panel.hide()

