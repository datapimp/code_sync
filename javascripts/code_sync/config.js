(function() {
  var CodeSync, root, _originalSetOption,
    __slice = [].slice;

  root = this;

  if (typeof exports !== "undefined") {
    CodeSync = exports;
  } else {
    CodeSync = root.CodeSync = {};
  }

  CodeSync.VERSION = "0.6.5";

  CodeSync.backends = {};

  CodeSync.util = {};

  CodeSync.plugins = {};

  CodeSync._config || (CodeSync._config = {
    defaultFileType: "coffeescript",
    assetCompilationEndpoint: "http://localhost:9295/source",
    serverInfoEndpoint: "http://localhost:9295/info",
    sprocketsEndpoint: "http://localhost:9295/assets",
    socketEndpoint: "http://localhost:9295/faye",
    editorToggleHotkey: "ctrl+j",
    debugMode: false
  });

  CodeSync.set = function(setting, value) {
    return CodeSync._config[setting] = value;
  };

  CodeSync.get = function(setting) {
    return CodeSync._config[setting];
  };

  CodeSync.enableLogging = function() {
    return CodeSync.set("debugMode", true);
  };

  CodeSync.log = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (CodeSync.get("debugMode") !== false) {
      args.unshift("CodeSync Log:");
      return console.log.apply(console, args);
    }
  };

  _originalSetOption = CodeMirror.prototype.setOption;

}).call(this);
