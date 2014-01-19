# The EditorPanel
# Wraps the EditorComponent and Toolbar


CodeSync.EditorPanel = Backbone.View.extend
  className: "embeddable-editor-panel"

  template: "embeddable-editor-panel"

  defaultEditorPlugins:[
    "ElementSync"
    "ColorPicker"
    "LanguageSelector"
  ]

  defaultToolbarItems:
    top:[
      icon: "comment"
      tooltop: "Select the language"
      action: "selectLanguage"
      section: "left"
    ,
      icon: "fullscreen"
      tooltip: "Re-arrange this panel"
      action: "rearrange"
      section: "right"
      eventListener: "mousedown"
    ,
      icon:     "expand-editor"
      tooltip:  "Expand this editor"
      action:   "expand"
      section:  "right"
    ]

  initialize: (@options)->
    _.extend(@, @options)

    @toolbarItems ||= @defaultToolbarItems || {}

    @editorPlugins ||= @defaultEditorPlugins

    @$el.html CodeSync.template(@template, @)

    @$el.removeClass 'active'

    Backbone.View::initialize.apply(@, arguments)

  addToolbarItem: (item, options={})->
    {position} = options

    itemElement   = $(CodeSync.template(item.template || "embeddable-toolbar-item", item))
    container     = @$(">.toolbar.#{ position }").removeClass('empty')

    if item.section?
      container = container.find('.' + item.section).removeClass('empty, fpo')

    container.append(itemElement)

    if item.action
      itemElement.on (item.eventListener || "click"), (e)=>
        @handleToolbarClick.call(@, item.action, item, e)

  handleToolbarClick: (action,item,e)->
    @[action]()

  preferences: ()->
    @preferencesPanel = new CodeSync.plugins.PreferencesPanel(editor: @)
    @preferencesPanel.show()

  setupCodeMirror: ()->
    @renderEditorComponent().setupCodeMirror()

  renderToolbars: ()->
    for position, items of @toolbarItems
      @addToolbarItem(item, {position}) for item in items

  renderEditorComponent: ()->
    @editor ||= new CodeSync.EditorComponent
      documentManager: @documentManager || @parent.documentManager
      plugins: @editorPlugins
      theme: @theme
      keyBindings: @keyBindings
      startMode: @startMode
      restrictMode: true
      onCodeMirrorSetup: (codeMirror, component)=>
        console.log "Setting up codemirror bindings on", @, component
        @setupCodeMirrorBindings(codeMirror, component)

    @editor.parent = @


    unless @editor.rendered is true
      @$('.editor-component').html(@editor.render().el)

    @editor

  renderIn: (container)->
    $(container).append @render().el
    @

  render: ()->
    @renderToolbars()
    @

  expand: ()->
    @parent.expandPanel(@)

  rearrange: ()->
    el        = @$el
    parent    = @parent

    parentEl  = @$el.parents('.codesync-embeddable')
    width     = @$el.width()
    height    = @$el.height()
    original  = @$el.position().left
    all       = @$el.parent().children('.embeddable-editor-panel')
    count     = all.length

    if @$el.is(".animating.ui-draggable")
      @$el.draggable('destroy').removeClass('animating')
      parentEl.removeClass('rearranging')
      return

    @$el.addClass('animating').draggable
      axis: 'x'
      handle: ".icon.icon-fullscreen"
      snap: ".embeddable-editor-panel"
      containment: ".codesync-embeddable"
      start: ()->
        parentEl.addClass 'rearranging'
      stop: ()->
        all.removeClass('animating')
        _.delay ()->
          parentEl.removeClass('rearranging')
          parent?.redraw()
        , 400

    @$el.siblings('.embeddable-editor-panel').droppable
      accept: @$el
      drop: (e,options)->
        target  = $(e.target)
        me      = $(@)
        all.removeClass('animating')

        me.animate(left: "#{ original }px" )

        _.delay ()->
          parentEl.removeClass('rearranging')
          parent?.redraw()
        , 400

  selectLanguage: ()->
    @editor.languageSelector.toggle()

  setOriginalPosition: (settings)->
    @$el.css(settings)
    @originalPosition = settings

  setKeyMap: ()->
    @editor.setKeyMap.apply(@editor, arguments)

  setTheme: ()->
    @editor.setTheme.apply(@editor, arguments)

  setupCodeMirrorBindings: (codeMirror, component)->
    codeMirror.on "focus", ()=>
      @trigger "focus", @, component, codeMirror