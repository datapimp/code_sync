CodeSync.TemplateEditor = CodeSync.AssetEditor.extend
  hideable: false
  autoRender: true
  renderVisible: true
  startMode: "skim"
  keyBindings: CodeSync.get("defaultKeyBindings") || "vim"
  position: "static"

  plugins:[
    "ModeSelector"
    "KeymapSelector"
    "ElementSync"
  ]

  pluginOptions:
    ModeSelector:
      showModes: "template"


  initialize:(@options={})->
    _.extend(@, @options)

    @plugins.push(plugin) for plugin in (@options.extraPlugins || [])

    CodeSync.AssetEditor::initialize.apply(@, arguments)