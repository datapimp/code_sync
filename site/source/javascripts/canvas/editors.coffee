CodeSync.canvasEditors = ()->
  window.canvasEditor = new CodeSync.AssetEditor
    hideable: false
    autoRender: true
    appendTo: "#editor-panel"
    renderVisible: true
    startMode: "skim"
    position: "static"
    plugins:[
      "ModeSelector"
      "KeymapSelector"
      "ElementSync"
      "DocumentManager"
    ]
