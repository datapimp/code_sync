CodeSync.ToolbarPanel::toolbarel = ".left"

plugins = [
  "ColorPicker"
  "ElementSync"
  "PreferencesPanel"
  "AssetSelector"
  "FileControls"
  "CompiledCodeViewer"
]

pluginOptions =
  ElementSync:
    toolbarEl: ".left"
  PreferencesPanel:
    showModes: "all"
    toolbarEl: ".right"
  FileControls:
    toolbarEl: ".right"
  AssetSelector:
    toolbarEl: ".right"

CodeSync.EditorPanel = Backbone.View.extend
  name: "editor-panel"

  className: "codesync-editor-panel"

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
    pluginOptions: pluginOptions
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
    pluginOptions: pluginOptions
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
    pluginOptions: pluginOptions
  ]

  initialize: (@options = {})->
    _.extend(@, @options)
    panel = @

    @$el.html CodeSync.template("editor_panel")

    @documentManager = new CodeSync.DocumentManager
      getEditor: ()-> panel.getCurrentEditor()

    Backbone.View::initialize.apply(arguments)

  set: (setting, value)->
    @$el.attr("data-#{ setting }", value)
    @[setting] = value
    value

  getCurrentEditor: ()->
    return @currentEditor if @currentEditor

    name = @$el.attr('data-current-editor')

    @assetEditors[name]

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

    @

  each: (args...)->
    editors = _(@assetEditors).values()
    _(editors).each(args...)

  setupEditorToolbar: ()->
    return unless @toolbarClass?

    if CodeSync.toolbars[@toolbarClass]?
      options = @toolbarOptions || {}
      options.editorPanel = @
      @toolbar = new CodeSync.toolbars[@toolbarClass](options)


    if @toolbar
      @$(@toolbarContainerSelector).append( @toolbar.render().el )

    @

  renderEditors: ()->
    @assetEditors ||= {}

    panel = @

    _(@editors).each (config,index)=>
      id = config.name || config.cid

      container = @$(@editorContainerSelector).eq(index)
      container.attr('data-editor', index)

      config.appendTo = container
      config.documentManager = @documentManager

      EditorClass = CodeSync[config.type] || CodeSync.AssetEditor

      config.document ||= {}
      config.document.localStorageKey = panel.name + ':' + index

      editor = @assetEditors[id] = new EditorClass(config)

      @defaultEditor ||= editor

      editor.on "codemirror:setup", (cm)->
        currentEditor = @
        cm.on "focus", ()->
          panel.setCurrentEditor(currentEditor)

      @currentEditor ||= editor

    @trigger "editors:loaded"
