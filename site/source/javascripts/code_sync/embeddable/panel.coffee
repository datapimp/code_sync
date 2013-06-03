CodeSync.EditorPanel = Backbone.View.extend
  className: "embeddable-editor-panel"

  template: "embeddable-editor-panel"

  defaultToolbarItems:
    top:[
      icon: "cog"
      tooltip: "Editor preferences"
      action: "preferences"
      section: "right"
    ,
      icon:     "resize-editor"
      tooltip:  "Resize this editor"
      action:   "resize"
      section:  "right"
    ]
    bottom:[
      icon: "link"
      tooltip: "Choose the keybinding configuration"
      action: "keybindings"
      section: "right"
    ]

  initialize: (@options)->
    _.extend(@, @options)

    @toolbarItems ||= @defaultToolbarItems || {}

    @$el.html CodeSync.template(@template, @)

  addToolbarItem: (item, options={})->
    {position} = options

    itemElement   = $(CodeSync.template(item.template || "embeddable-toolbar-item", item))
    container     = @$(">.toolbar.#{ position }").removeClass('empty')

    if item.section?
      container = container.find('.' + item.section).removeClass('empty, fpo')

    container.append(itemElement)

    if item.action
      itemElement.on "click", (e)=>
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
      startMode: "coffeescript"
      theme: "lesser-dark"
      keyMap: "vim"

    unless @editor.rendered is true
      @$('.editor-component').html(@editor.render().el)

    @editor


  renderIn: (container)->
    $(container).append @render().el
    @

  render: ()->
    @renderToolbars()
    @

  resize: ()->
    @parent.resizePanel(@)

  setOriginalPosition: (settings)->
    @$el.css(settings)
    @originalPosition = settings