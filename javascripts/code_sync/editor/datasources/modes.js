(function() {
  var modes;

  CodeSync.Modes = Backbone.Collection.extend({
    initialize: function(models, options) {
      var attributes, key, value;
      if (models == null) {
        models = [];
      }
      if (options == null) {
        options = {};
      }
      models = (function() {
        var _results;
        _results = [];
        for (key in modes) {
          value = modes[key];
          _results.push(attributes = {
            id: key,
            name: value.name || key,
            codeMirrorMode: value.codeMirrorMode || key,
            extension: value.extension,
            extensionRegex: new RegExp("" + value.extension),
            defaultContent: value.defaultContent
          });
        }
        return _results;
      })();
      Backbone.Collection.prototype.initialize.apply(this, arguments);
      return this.reset(models, {
        silent: true
      });
    },
    findModeFor: function(pathOrFilename) {
      var mode,
        _this = this;
      if (pathOrFilename == null) {
        pathOrFilename = "";
      }
      if (!pathOrFilename.match(/\./)) {
        pathOrFilename = "." + pathOrFilename;
      }
      mode = this.detect(function(model) {
        var regex;
        regex = model.get("extensionRegex");
        return regex.exec(pathOrFilename);
      });
      return mode != null ? mode.get("codeMirrorMode") : void 0;
    },
    findExtensionFor: function(mode) {
      mode = this.detect(function(model) {
        return model.get('codeMirrorMode') === mode || model.get('id') === mode;
      });
      return mode != null ? mode.get("extension") : void 0;
    },
    defaultMode: function() {
      return this.get(CodeSync.get("defaultFileType")) || this.first();
    }
  });

  CodeSync.Modes.getMode = function(id) {
    return CodeSync.Modes.get().get(id);
  };

  CodeSync.Modes.guessModeFor = function(pathOrFilename) {
    return CodeSync.Modes.get().findModeFor(pathOrFilename);
  };

  CodeSync.Modes.guessExtensionFor = function(mode) {
    return CodeSync.Modes.get().findExtensionFor(mode);
  };

  CodeSync.Modes.get = function() {
    var _base;
    return (_base = CodeSync.Modes).singleton || (_base.singleton = new CodeSync.Modes());
  };

  CodeSync.Modes.defaultMode = function() {
    return CodeSync.Modes.get().defaultMode();
  };

  modes = {
    coffeescript: {
      extension: ".coffee",
      defaultContent: "# You are currently in coffeescript mode."
    },
    sass: {
      name: "Sass",
      extension: ".css.sass",
      defaultContent: "// You are currently in Sass mode."
    },
    scss: {
      codeMirrorMode: "css",
      extension: ".css.scss",
      name: "SCSS",
      defaultContent: "/* You are currently in SCSS mode. */"
    },
    skim: {
      extension: ".jst.skim",
      defaultContent: "// You are currently in Skim mode.\n// The contents of this template will be available on the JST object.",
      template: true
    },
    css: {
      name: "CSS",
      extension: ".css",
      defaultContent: "/* You are currently in raw CSS mode. */"
    },
    javascript: {
      name: "Javascript",
      extension: ".js",
      defaultContent: "/* You are currently in raw JS mode. */"
    }
  };

}).call(this);
