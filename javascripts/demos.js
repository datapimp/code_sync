(function() {
  var mode, _i, _len, _ref;

  $('.editor-container').empty();

  _ref = ["coffeescript", "skim", "scss"];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    mode = _ref[_i];
    window["" + mode + "Editor"] = new CodeSync.AssetEditor({
      hideable: false,
      autoRender: true,
      appendTo: ".editor-container",
      renderVisible: true,
      startMode: mode,
      position: "static",
      document: {
        localStorageKey: "demo." + mode
      },
      plugins: ["ModeSelector", "KeymapSelector"]
    });
  }

  CodeSync.onScriptChange = function(changeObject) {
    if (changeObject.mode === "skim" && changeObject.name === "codesync") {
      return $('.canvas-container').html(JST["codesync"]());
    }
  };

  _.delay(function() {
    window.skimEditor.currentDocument.trigger("change:contents");
    window.scssEditor.currentDocument.trigger("change:contents");
    return window.coffeescriptEditor.currentDocument.trigger("change:contents");
  }, 1200);

}).call(this);
