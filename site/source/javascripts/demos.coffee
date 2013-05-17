$('.editor-container').empty()

for mode in ["coffeescript","skim","scss"]
  new CodeSync.AssetEditor
    hideable: false
    autoRender: true
    appendTo: ".editor-container"
    renderVisible: true
    startMode: mode
    position: "static"
    plugins:[
      "ModeSelector"
    ]


CodeSync.onScriptChange = (changeObject)->
  if changeObject.mode is "skim" and changeObject.name is "codesync"
    $('.canvas-container').html JST["codesync"]()
