$('.editor-container').empty()

for mode in ["coffeescript","skim","scss"]
  window["#{ mode }Editor"] = new CodeSync.AssetEditor
    hideable: false
    autoRender: true
    appendTo: ".editor-container"
    renderVisible: true
    startMode: mode
    position: "static"
    document:
      localStorageKey: "demo.#{ mode }"
    plugins:[
      "ModeSelector"
      "KeymapSelector"
    ]


CodeSync.onScriptChange = (changeObject)->
  if changeObject.mode is "skim" and changeObject.name is "codesync"
    $('.canvas-container').html JST["codesync"]()


_.delay ()->
    window.skimEditor.currentDocument.trigger "change:contents"
    window.scssEditor.currentDocument.trigger "change:contents"
    window.coffeescriptEditor.currentDocument.trigger "change:contents"
, 1200
