#= require_tree ./demos
#= require_self

window.defaultContentFor = (mode)->
  window["#{ mode }Default"]

window.setupEditors = _.once ()->
  for mode, index in ["scss","skim","coffeescript"]

    window["#{ mode }Editor"] ||= new CodeSync.AssetEditor
      hideable: false
      autoRender: true
      appendTo: ".editor-container"
      renderVisible: true
      startMode: mode
      name: "panel-#{ index + 1 }"
      position: "static"
      document:
        content: "shit"
        contents: defaultContentFor(mode)

      plugins:[
        "ModeSelector"
        "KeymapSelector"
      ]

  scssEditor.addPlugin("ColorPicker")


setupEditors()

window.layoutSelector ||= new LayoutSelector()
$('body').append( layoutSelector.render().el ) unless $('#layout-selector').length > 0

CodeSync.onScriptChange ||= (changeObject)->
  if changeObject.mode is "skim" and changeObject.name is "codesync"
    $(".canvas-container").html JST["codesync"]()
    window.coffeeScriptEditor.currentDocument.trigger "change:contents"

_.delay ()->
    window.skimEditor.currentDocument.trigger "change:contents"
    window.scssEditor.currentDocument.trigger "change:contents"
, 600

_.delay ()->
  window.coffeescriptEditor.currentDocument.trigger "change:contents"
  window.enableGlobalEditor()
, 1800
