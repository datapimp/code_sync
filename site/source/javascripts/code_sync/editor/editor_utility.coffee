CodeSync.EditorUtility = Backbone.View.extend
  buttonText: undefined

  buttonIcon: undefined

  buttonTemplate: "toolbar_button"

  entranceEffect: "bounceInDown"

  exitEffect: "bounceOutUp"

  visible: false

  panelTemplate: "toolbar_panel"

  availableInModes: "all"

  alignment: undefined

  initialize: (@options)->
    _.extend(@, @options)

    Backbone.View::initialize.apply(@, arguments)

    @editor?.on "change:mode", @checkAvailabilityInMode, @
    @editor?.on "document:loaded", @checkAvailabilityInMode, @

    @$el.addClass "#{ @alignment }-aligned" if @alignment?

  checkAvailabilityInMode: ()->
    return @buttonElement.show() if @availableInModes is "all" || !@availableInModes?

    type = @editor.mode?.type?() || @editor.currentDocument.type()

    if type is @availableInModes
      @buttonElement.show()
    else
      @buttonElement.hide()

  toggle: (options={})->
    if @visible then @hide(options) else @show(options)

  show: (options={})->
    @removeOtherEditorUtilitys()
    @render()
    @$el.removeClass(@exitEffect)
    @$el.addClass("animated #{ @entranceEffect }")
    @visible = true
    @

  hide: (options={})->
    @$el.removeClass(@entranceEffect)
    @$el.addClass("animated #{ @exitEffect }")
    @visible = false
    @

  removeOtherEditorUtilitys: ()->
    $(@renderTo()).find('.editor-utility').addClass("animated #{ @exitEffect }").attr('data-removed',true)

  templateOptions: ->
    @options

  getButtonWrapper: ()->
    wrapper               = @editor.toolbarWrapperElement()
    wrapper               = wrapper.find(@toolbarEl) if @toolbarEl?

    wrapper

  setupButtonElement: ()->
    return @buttonElement if @buttonElement

    buttonId              = _.uniqueId()
    wrapper               = @getButtonWrapper()
    html                  = $(CodeSync.template(@buttonTemplate, buttonId: buttonId, icon: @buttonIcon, text: @buttonText, tooltip: @tooltip))

    wrapper.append(html)

    @buttonElement = wrapper.find("[data-button-id='#{ buttonId }']").eq(0)

    @buttonElement.on "click", ()=>
      @toggle(withEffect: true)

    @buttonElement

  applyTemplate: ()->
    @$el.html CodeSync.template(@panelTemplate, @templateOptions())

  render: () ->
    if @rendered is true
      return @
    else
      return @ if @beforeRender?() is false

      @$el.addClass("editor-utility")
      @applyTemplate()
      $(@renderTo()).append(@el)

      @afterRender?()
      @rendered = true
      @checkAvailabilityInMode()
      return @

original = CodeSync.EditorUtility.extend


CodeSync.EditorUtility.setup = (editor,options={})->
  {PluginClass} = options

  options.editor = editor
  options.alignment = "top"

  panel = new PluginClass(options)

  if panel.handle
    editor.views[panel.handle] = panel

  panel.setupButtonElement()

  panel.renderTo = ()-> editor.$('.codemirror-wrapper')

  editor.on "codemirror:setup", (cm)->
    cm.on "focus", ()-> panel.hide()

