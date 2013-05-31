CodeSync.TemplateEditor = CodeSync.AssetEditor.extend
  hideable: false
  autoRender: true
  renderVisible: true
  startMode: "haml"
  keyBindings: CodeSync.get("defaultKeyBindings") || "vim"
  position: "static"

  initialize:(@options={})->
    _.extend(@, @options)

    if @options.extraPlugins
      @plugins.push(plugin) for plugin in (@options.extraPlugins)

    CodeSync.AssetEditor::initialize.apply(@, arguments)