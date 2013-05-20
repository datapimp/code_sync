window.coffeescriptDefault = """
# This coffeescript content will be automatically evaluated any time you
# change some stuff.
CodeSync.onScriptChange ||= (changeObject)->
  if changeObject.mode is "skim" and changeObject.name is "codesync"
    $(".canvas-container").html JST["codesync"]()

(CodeSync.tour ||= {}).step = 0
CodeSync.enableTour(restart: true)
"""

window.skimDefault = """
.editor-demos
  h1 CodeSync Editor Demos
  p
    | You can embed as many CodeSync.AssetEditor as you want in any configuration you want, and they will hook right up to the asset pipeline in your project and allow you to use your assets to create a little front end development canvas.
  p
    | In this example here, I am using a CodeSync.onScriptChange hook to wire up the automatic rendering of a template file whenever it changes, to display the contents of that template as it would be styled in my project.

  h2.tour-button Click Here to take a tour son
"""

window.scssDefault = """
/* scss */

@import url(http://fonts.googleapis.com/css?family=Lobster|Raleway);

body {
  font-family: "Raleway";
  background: #656892;
  color: #ffffff;
}

.bubble {
  width: 250px;
  background-color: rgba(30,30,30,0.75);
  border-radius: 12px;
  padding: 12px;
  box-shadow: 0 0 6px #000000;
  h4 {
    font-family: "Lobster";
    text-align: center;
  }

  a.next {
    font-family: "Lobster";
  display: block;
    text-align: right;
    cursor: pointer;
  }
}

.editor-demos {
  padding-left: 20px;
  p {
    max-width: 600px;
  }
  h1,h2 {
    font-family: "Lobster";
    text-shadow: 3px 6px #333333;
    font-weight: 400;
  }
  h1 {
    font-size: 88px;
  }
  h2 {
    font-size: 48px;
    cursor: pointer;
    text-shadow: 2px 4px #333333;
  }
}
"""
