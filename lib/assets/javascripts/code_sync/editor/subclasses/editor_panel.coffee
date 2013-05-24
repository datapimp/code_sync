CodeSync.EditorPanel = Backbone.View.extend
  className: "codesync-editor-panel"

  template: "code_sync/editor/subclasses/editor_panel_template"

  editors:[
    type: "TemplateEditor"
    name: "template_editor"
    document:
      localStorageKey: "panel:1"
  ,
    name: "style_editor"
    hideable: false
    autoRender: true
    renderVisible: true
    startMode: "scss"
    keyBindings: CodeSync.get("defaultKeyBindings")
    position: "static"
    plugins:[
      "ModeSelector"
      "KeymapSelector"
      "ColorPicker"
    ]
    document:
      localStorageKey: "panel:2"

    pluginOptions:
      ModeSelector:
        showModes: "style"
  ,
    name: "script_editor"
    hideable: false
    autoRender: true
    renderVisible: true
    startMode: "coffeescript"
    keyBindings: CodeSync.get("defaultKeyBindings")
    position: "static"
    plugins:[
      "ModeSelector"
      "KeymapSelector"
    ]
    document:
      localStorageKey: "panel:3"
    pluginOptions:
      ModeSelector:
        showModes: "script"
  ]

  initialize: ()->
    @$el.append "<div class='editor-panel-wrapper' />"

    Backbone.View::initialize.apply(arguments)

  render: ()->
    @delegateEvents()
    @

  renderIn: (containerElement)->
    $(containerElement).html(@render().el)
    @renderEditors()

  each: (args...)->
    editors = _(@assetEditors).values()
    _(editors).each(args...)

  renderEditors: ()->
    @assetEditors ||= {}

    for config, index in @editors
      id = config.name || config.cid

      @$('.editor-panel-wrapper').append JST[@template]()
      config.appendTo = @$('.editor-panel .editor').eq(index)

      EditorClass = CodeSync[config.type] || CodeSync.AssetEditor

      @assetEditors[id] = new EditorClass(config)

    @trigger "editors:loaded"


