plugins = [
  "ColorPicker"
  "ElementSync"
  "ScriptLoader"
  "StylesheetLoader"
  "PreferencesPanel"
  "DocumentTabs"
]

CodeSync.EditorPanel = Backbone.View.extend
  className: "codesync-editor-panel"

  events:
    "click #target-selector li[data-option]" : "selectTarget"
    "click #layout-selector li[data-option]" : "selectLayout"


  layout: "3"

  target: "canvas"

  toolbarClass: undefined

  toolbarContainerSelector: ".editor-panel-toolbar"

  editorContainerSelector: ".editor-wrapper .editor"

  editors:[
    type: "TemplateEditor"
    name: "template_editor"
    enableStatusMessages: "error"
    plugins: plugins

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
    plugins: plugins
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
    plugins: plugins
    document:
      localStorageKey: "panel:3"
  ]

  initialize: ()->
    @$el.html CodeSync.template("editor_panel")
    Backbone.View::initialize.apply(arguments)

  selectTarget: (e)->
    el = @$(e.target).closest('li[data-option]')
    option = el.data('option')
    el.siblings().removeClass('active')
    el.addClass('active')

    @$el.attr('data-target', @target = option)
    @trigger "target:change", option

  selectLayout: (e)->
    el = @$(e.target).closest('li[data-option]')
    option = el.data('option')

    el.siblings().removeClass('active')
    el.addClass('active')

    @$el.attr('data-layout', @layout = option)
    @trigger "layout:change", option

  setCurrentEditor: (editor)->
    @$el.attr('data-current-editor', editor.name || editor.cid)
    @currentEditor = editor

  render: ()->
    @delegateEvents()
    @$el.attr('data-layout',"3")
    @

  renderIn: (containerElement)->
    $(containerElement).html(@render().el)

    @renderEditors()
    @setupEditorToolbar()

  each: (args...)->
    editors = _(@assetEditors).values()
    _(editors).each(args...)

  setupEditorToolbar: ()->
    if CodeSync.toolbars[@toolbarClass]?
      @toolbar = new CodeSync.toolbars[@toolbarClass](@toolbarOptions || {})

  renderEditors: ()->
    @assetEditors ||= {}

    panel = @

    _(@editors).each (config,index)=>
      id = config.name || config.cid

      container = @$(@editorContainerSelector).eq(index)
      container.attr('data-editor', index)
      config.appendTo = container

      EditorClass = CodeSync[config.type] || CodeSync.AssetEditor

      editor = @assetEditors[id] = new EditorClass(config)

      editor.on "codemirror:setup", (cm)->
        currentEditor = @
        cm.on "focus", ()->
          panel.setCurrentEditor(currentEditor)

      @currentEditor ||= editor

    @trigger "editors:loaded"


