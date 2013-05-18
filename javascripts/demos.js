(function() {
  var LayoutSelector;

  window.coffeescriptDefault = "";

  window.skimDefault = ".masthead\n  h1 CodeSync Editor Components\n  p Use them however you want, boo.\n\n.explanations\n  .explanation.coffeescript\n    h4\n      | Coffeescript&nbsp;\n    a href=\"http://coffeescript.org\" Docs\n    p Any coffeescript you enter in the above box will be auto-evaluated\n\n  .explanation.skim\n    h4\n      | Skim&nbsp;\n    a href=\"https://github.com/firebaugh/skim\" Docs\n    p The markup you put in the above editor will be rendered in the canvas below whenever you change it.\n\n  .explanation.scss\n    h4\n      | SCSS&nbsp;\n    a href=\"http://sass-lang.org\" Docs\n    p\n      | The style rules you define in the above editor will be applied to the canvas below.\n    p\n      | It even has a really cool color picker.";

  window.scssDefault = "\n@import url(http://fonts.googleapis.com/css?family=Lobster|Raleway);\n\nbody {\n  background-color: #449add;\n}\n\n.masthead {\n  h1 {\n    font-size: 60px;\n    color: #ffffff;\n  text-shadow: 2px 2px #333333;\n    font-weight: 400;\n  }\n  position: fixed;\n  bottom: 120px;\n  left: 50%;\n  width: 800px;\n  margin-left: -400px;\n  text-align: center;\n}\n.canvas-container {\n  h1,h2,h3,h4,h5 {\n    font-family: \"Lobster\";\n  }\n  a,p {\n    font-family: \"Raleway\";\n  }\n}\n.explanations {\n  top: 25px;\n}\n\n.explanation {\n  background: rgba(0,0,0,0.75);\n  a, p, h4 {\n    color: #ffffff;\n  }\n}\n\n.explanation {\n  border-radius: 8px;\n  box-shadow: 0 0 6px #333333;\n  position: absolute;\n  width: 25%;\n  margin: 30px auto;\n  text-align: center;\n  padding: 0px 20px;\n  margin-left: 25px;\n  height: 225px;\n  p {\n    text-align: left;\n  }\n}\n\n.explanation.coffeescript {\n  left: 66.66666%;\n}\n\n.explanation.skim {\n  left: 33.33333%;\n}\n\n.explanation.scss {\n  left: 0%;\n}";

  LayoutSelector = Backbone.View.extend({
    id: "layout-selector",
    tagName: "ul",
    events: {
      "click .opt1": function() {
        return $('.editor-container').attr('data-layout', 'one');
      },
      "click .opt2": function() {
        return $('.editor-container').attr('data-layout', 'two');
      },
      "click .opt3": function() {
        return $('.editor-container').attr('data-layout', 'three');
      }
    },
    render: function() {
      var n, _i, _len, _ref;
      _ref = [1, 2, 3];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        n = _ref[_i];
        this.$el.append("<li class='opt" + n + "'>" + n + "</li>");
      }
      return this;
    }
  });

  window.setupEditors = _.once(function() {
    var index, mode, _i, _len, _name, _ref;
    _ref = ["scss", "skim", "coffeescript"];
    for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
      mode = _ref[index];
      if (("" + (localStorage.getItem("demo." + mode))).length < 10) {
        localStorage.setItem("demo." + mode, window["" + mode + "Default"]);
      }
      window[_name = "" + mode + "Editor"] || (window[_name] = new CodeSync.AssetEditor({
        hideable: false,
        autoRender: true,
        appendTo: ".editor-container",
        renderVisible: true,
        startMode: mode,
        name: "panel-" + (index + 1),
        position: "static",
        document: {
          localStorageKey: "demo." + mode
        },
        plugins: ["ModeSelector", "KeymapSelector", "DocumentManager"]
      }));
    }
    return scssEditor.addPlugin("ColorPicker");
  });

  CodeSync.onScriptChange = function(changeObject) {
    if (changeObject.mode === "skim" && changeObject.name === "codesync") {
      return $('.canvas-container').html(JST["codesync"]());
    }
  };

  setupEditors();

  window.layoutSelector || (window.layoutSelector = new LayoutSelector());

  if (!($('#layout-selector').length > 0)) {
    $('body').append(layoutSelector.render().el);
  }

  _.delay(function() {
    window.skimEditor.currentDocument.trigger("change:contents");
    window.scssEditor.currentDocument.trigger("change:contents");
    return window.coffeescriptEditor.currentDocument.trigger("change:contents");
  }, 1200);

}).call(this);
