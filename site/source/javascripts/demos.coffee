LayoutSelector = Backbone.View.extend
  id: "layout-selector"
  tagName: "ul"

  events:
    "click .opt1": ()->
      $('.editor-container').attr('data-layout','one')

    "click .opt2": ()->
      $('.editor-container').attr('data-layout','two')

    "click .opt3": ()->
      $('.editor-container').attr('data-layout','three')

  render: ()->
    for n in [1,2,3]
      @$el.append "<li class='opt#{n}'>#{n}</li>"

    @

window.setupEditors = _.once ()->
  for mode, index in ["coffeescript","skim","scss"]
    window["#{ mode }Editor"] ||= new CodeSync.AssetEditor
      hideable: false
      autoRender: true
      appendTo: ".editor-container"
      renderVisible: true
      startMode: mode
      name: "panel-#{ index + 1 }"
      position: "static"
      document:
        localStorageKey: "demo.#{ mode }"
      plugins:[
        "ModeSelector"
        "KeymapSelector"
        "DocumentManager"
      ]


  scssEditor.addPlugin("ColorPicker")

CodeSync.onScriptChange = (changeObject)->
  if changeObject.mode is "skim" and changeObject.name is "codesync"
    $('.canvas-container').html JST["codesync"]()

setupEditors()

window.layoutSelector ||= new LayoutSelector()

$('body').append( layoutSelector.render().el ) unless $('#layout-selector').length > 0

_.delay ()->
    window.skimEditor.currentDocument.trigger "change:contents"
    window.scssEditor.currentDocument.trigger "change:contents"
    window.coffeescriptEditor.currentDocument.trigger "change:contents"
, 1200
