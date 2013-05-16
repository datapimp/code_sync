(function() {
  var codeEditor, styleEditor, templateEditor;

  styleEditor = new CodeSync.AssetEditor({
    hideable: false,
    autoRender: true,
    appendTo: "#styleEditor",
    renderVisible: true,
    startMode: "scss",
    position: "static",
    plugins: ["ModeSelector"]
  });

  codeEditor = new CodeSync.AssetEditor({
    hideable: false,
    autoRender: true,
    appendTo: "#codeEditor",
    renderVisible: true,
    position: "static",
    startMode: "coffeescript",
    plugins: ["ModeSelector"]
  });

  templateEditor = new CodeSync.AssetEditor({
    hideable: false,
    autoRender: true,
    renderVisible: true,
    position: "static",
    appendTo: "#templateEditor",
    startMode: "skim",
    defaultDocumentName: "codesync_template",
    plugins: ["ModeSelector"]
  });

  CodeSync.onScriptChange = function() {
    return $('#canvas').html(JST["codesync_template"]);
  };

}).call(this);
