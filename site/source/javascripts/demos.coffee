window.coffeescriptDefault = """
"""

window.skimDefault = """
.masthead
  h1 CodeSync Editor Components
  p Use them however you want, boo.

.explanations
  .explanation.coffeescript
    h4
      | Coffeescript&nbsp;
    a href="http://coffeescript.org" Docs
    p Any coffeescript you enter in the above box will be auto-evaluated

  .explanation.skim
    h4
      | Skim&nbsp;
    a href="https://github.com/firebaugh/skim" Docs
    p The markup you put in the above editor will be rendered in the canvas below whenever you change it.

  .explanation.scss
    h4
      | SCSS&nbsp;
    a href="http://sass-lang.org" Docs
    p
      | The style rules you define in the above editor will be applied to the canvas below.
    p
      | It even has a really cool color picker.
"""

window.scssDefault = """

@import url(http://fonts.googleapis.com/css?family=Lobster|Raleway);

body {
  background-color: #449add;
}

.masthead {
  h1 {
    font-size: 60px;
    color: #ffffff;
  text-shadow: 2px 2px #333333;
    font-weight: 400;
  }
  position: fixed;
  bottom: 120px;
  left: 50%;
  width: 800px;
  margin-left: -400px;
  text-align: center;
}
.canvas-container {
  h1,h2,h3,h4,h5 {
    font-family: "Lobster";
  }
  a,p {
    font-family: "Raleway";
  }
}
.explanations {
  top: 25px;
}

.explanation {
  background: rgba(0,0,0,0.75);
  a, p, h4 {
    color: #ffffff;
  }
}

.explanation {
  border-radius: 8px;
  box-shadow: 0 0 6px #333333;
  position: absolute;
  width: 25%;
  margin: 30px auto;
  text-align: center;
  padding: 0px 20px;
  margin-left: 25px;
  height: 225px;
  p {
    text-align: left;
  }
}

.explanation.coffeescript {
  left: 66.66666%;
}

.explanation.skim {
  left: 33.33333%;
}

.explanation.scss {
  left: 0%;
}
"""

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
  for mode, index in ["scss","skim","coffeescript"]

    if "#{ localStorage.getItem("demo.#{ mode }") }".length < 10
      localStorage.setItem("demo.#{ mode }", window["#{ mode }Default"] )

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

