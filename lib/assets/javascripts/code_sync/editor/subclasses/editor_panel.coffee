CodeSync.EditorPanel = Backbone.View.extend
  className: "codesync-editor-panel"

  events:
    "click #target-selector li[data-option]" : "selectTarget"
    "click #layout-selector li[data-option]" : "selectLayout"

  editors:[
    type: "TemplateEditor"
    name: "template_editor"
    enableStatusMessages: "error"
    document:
      localStorageKey: "panel:1"
  ,
    name: "style_editor"
    hideable: false
    autoRender: true
    renderVisible: true
    startMode: "scss"
    enableStatusMessages: "error"
    keyBindings: CodeSync.get("defaultKeyBindings")
    position: "static"
    document:
      localStorageKey: "panel:2"
  ,
    name: "script_editor"
    hideable: false
    autoRender: true
    renderVisible: true
    startMode: "coffeescript"
    enableStatusMessages: "error"
    keyBindings: CodeSync.get("defaultKeyBindings")
    position: "static"
    document:
      localStorageKey: "panel:3"
    plugins:[
      "ScriptLoader"
    ]
  ]

  initialize: ()->
    @$el.html CodeSync.template("editor_panel")
    Backbone.View::initialize.apply(arguments)

  selectTarget: (e)->
    el = @$(e.target).closest('li[data-option]')
    option = el.data('option')
    el.siblings().removeClass('active')
    el.addClass('active')

    @$el.attr('data-target', option)
    @trigger "target:change", option

  selectLayout: (e)->
    el = @$(e.target).closest('li[data-option]')
    option = el.data('option')
    el.siblings().removeClass('active')
    el.addClass('active')

    @$el.attr('data-layout', option)
    @trigger "layout:change", option

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

      container = @$('.editor-wrapper .editor').eq(index)

      container.attr('data-editor', index)

      config.appendTo = container

      EditorClass = CodeSync[config.type] || CodeSync.AssetEditor

      @assetEditors[id] = new EditorClass(config)

    @trigger "editors:loaded"


