CodeSync.canvasEditors = ()->

  window.templateEditor = new CodeSync.AssetEditor
    hideable: false
    autoRender: true
    appendTo: "#front-end-editors-wrapper #panel-1"
    renderVisible: true
    startMode: "skim"
    keyBindings: "vim"
    position: "static"
    document:
      localStorageKey: "panel:1"

    plugins:[
      "ModeSelector"
      "KeymapSelector"
      "ElementSync"
    ]

  window.styleEditor = new CodeSync.AssetEditor
    hideable: false
    autoRender: true
    appendTo: "#front-end-editors-wrapper #panel-2"
    renderVisible: true
    startMode: "scss"
    keyBindings: "vim"
    position: "static"
    plugins:[
      "ModeSelector"
      "KeymapSelector"
    ]
    document:
      localStorageKey: "panel:2"

  window.coffeescriptEditor = new CodeSync.AssetEditor
    hideable: false
    autoRender: true
    appendTo: "#front-end-editors-wrapper #panel-3"
    renderVisible: true
    startMode: "coffeescript"
    keyBindings: "vim"
    position: "static"
    plugins:[
      "ModeSelector"
      "KeymapSelector"
    ]
    document:
      localStorageKey: "panel:3"
