(function() {
  var helpers,
    __slice = [].slice;

  CodeSync.Document = Backbone.Model.extend({
    callbackDelay: 150,
    initialize: function(attributes, options) {
      var localKey, _base,
        _this = this;
      this.attributes = attributes;
      if (localKey = this.attributes.localStorageKey) {
        (_base = this.attributes).contents || (_base.contents = localStorage.getItem(localKey));
      }
      Backbone.Model.prototype.initialize.apply(this, arguments);
      this.on("change:contents", this.onContentChange);
      this.on("change:name", function() {
        _this.set("mode", _this.determineMode());
        return _this.set("display", _this.nameWithoutExtension());
      });
      return this.on("change:mode", function() {
        return _this.set('extension', _this.determineExtension(), {
          silent: true
        });
      });
    },
    url: function() {
      return CodeSync.get("assetCompilationEndpoint");
    },
    saveToDisk: function() {
      if (this.isSaveable()) {
        return this.sendToServer(true, "saveToDisk");
      }
    },
    loadSourceFromDisk: function(callback) {
      var _this = this;
      return $.ajax({
        url: "" + (this.url()) + "?path=" + (this.get('path')),
        type: "GET",
        success: function(response) {
          if (response == null) {
            response = {};
          }
          if (response.success === true && (response.contents != null)) {
            _this.set("contents", response.contents, {
              silent: true
            });
            return callback(_this);
          }
        }
      });
    },
    toJSON: function() {
      return {
        name: this.nameWithoutExtension(),
        path: this.get('path'),
        extension: this.get('extension') || this.determineExtension(),
        contents: this.toContent()
      };
    },
    nameWithoutExtension: function() {
      var extension;
      extension = this.get('extension') || this.determineExtension();
      return (this.get("name") || "untitled").replace(extension, '');
    },
    toMode: function() {
      var mode, modeModel;
      mode = this.get("mode") || this.determineMode();
      return modeModel = CodeSync.Modes.getMode(mode);
    },
    toCodeMirrorMode: function() {
      var _ref;
      return (_ref = this.toMode()) != null ? _ref.get("codeMirrorMode") : void 0;
    },
    toCodeMirrorDocument: function() {
      return CodeMirror.Doc(this.toContent(), this.toCodeMirrorMode(), 0);
    },
    toCodeMirrorOptions: function() {
      return this.toMode().get("codeMirrorOptions");
    },
    toContent: function() {
      var _ref;
      return "" + (this.get("contents") || ((_ref = this.toMode()) != null ? _ref.get("defaultContent") : void 0) || " ");
    },
    onContentChange: function() {
      var localKey;
      if (localKey = this.get("localStorageKey")) {
        localStorage.setItem(localKey, this.get("contents"));
      }
      return this.sendToServer(false, "onContentChange");
    },
    sendToServer: function(allowSaveToDisk, reason) {
      var data,
        _this = this;
      if (allowSaveToDisk == null) {
        allowSaveToDisk = false;
      }
      if (reason == null) {
        reason = "";
      }
      if (!this.isSaveable()) {
        allowSaveToDisk = false;
      }
      data = allowSaveToDisk === true ? this.toJSON() : _(this.toJSON()).pick('name', 'extension', 'contents');
      CodeSync.log("Sending Data To " + (CodeSync.get("assetCompilationEndpoint")), data);
      return $.ajax({
        type: "POST",
        url: CodeSync.get("assetCompilationEndpoint"),
        data: JSON.stringify(data),
        error: function(response) {
          return CodeSync.log("Document Process Error", arguments);
        },
        success: function(response) {
          var _ref, _ref1;
          CodeSync.log("Document Process Response", response);
          if (response.success === true) {
            _this.trigger("status", {
              type: "success",
              message: _this.successMessage(reason)
            });
          }
          if (response.success === true && (response.compiled != null)) {
            _this.set("compiled", response.compiled);
          }
          if (response.success === false && (response.error != null)) {
            _this.set("error", (_ref = response.error) != null ? _ref.message : void 0);
            return _this.trigger("status", {
              type: "error",
              message: (_ref1 = response.error) != null ? _ref1.message : void 0
            });
          }
        }
      });
    },
    loadInPage: function(options) {
      if (options == null) {
        options = {};
      }
      if (this.type() === "stylesheet") {
        return helpers.processStyleContent.call(this, this.get('compiled'));
      } else if (this.type() === "script" || this.type() === "template") {
        helpers.processScriptContent.call(this, this.get('compiled'));
        if (options.complete) {
          return _.delay(options.complete, options.delay || this.callbackDelay);
        }
      }
    },
    type: function() {
      switch (this.get("mode")) {
        case "css":
        case "sass":
        case "scss":
        case "less":
          return "stylesheet";
        case "coffeescript":
        case "javascript":
          return "script";
        case "skim":
        case "mustache":
        case "jst":
        case "haml":
        case "eco":
          return "template";
      }
    },
    missingFileName: function() {
      var name;
      name = this.get('path') || this.get('name');
      return !(name != null) || name.length === 0;
    },
    determineExtension: function() {
      var extension, filename;
      filename = this.get("path") || this.get("name");
      if (extension = CodeSync.Document.getExtensionFor(filename)) {
        return extension;
      }
      if (this.get("mode") != null) {
        return CodeSync.Modes.guessExtensionFor(this.get('mode') || CodeSync.get("defaultFileType"));
      }
    },
    determineMode: function() {
      var path;
      path = this.get("path") || this.get("name") || this.get("extension");
      return CodeSync.Modes.guessModeFor(path);
    },
    successMessage: function(reason) {
      if (this.type() === "template") {
        return "Success.  Template will be available as JST[\"" + (this.nameWithoutExtension()) + "\"]";
      }
    },
    isSticky: function() {
      return (this.get("sticky") != null) === true;
    },
    isSaveable: function() {
      var _ref;
      return ((_ref = this.get("path")) != null ? _ref.length : void 0) > 0 && !this.get("doNotSave");
    }
  });

  CodeSync.Document.getFileNameFrom = function(string) {
    if (string == null) {
      string = "";
    }
    return string.split('/').pop();
  };

  CodeSync.Document.getExtensionFor = function(string) {
    var filename, fname, rest, val, _ref;
    if (string == null) {
      string = "";
    }
    filename = CodeSync.Document.getFileNameFrom(string);
    _ref = filename.split('.'), fname = _ref[0], rest = 2 <= _ref.length ? __slice.call(_ref, 1) : [];
    if (val = rest.length > 0 && rest.join('.')) {
      return "." + val;
    }
  };

  CodeSync.Documents = Backbone.Collection.extend({
    model: CodeSync.Document,
    nextId: function() {
      return this.models.length + 1;
    },
    findOrCreateForPath: function(path, callback) {
      var display, documentModel, extension, id, name,
        _this = this;
      if (path == null) {
        path = "";
      }
      documentModel = this.detect(function(documentModel) {
        var _ref;
        return (_ref = documentModel.get('path')) != null ? _ref.match(path) : void 0;
      });
      if (documentModel != null) {
        return typeof callback === "function" ? callback(documentModel) : void 0;
      } else {
        name = CodeSync.Document.getFileNameFrom(path);
        extension = CodeSync.Document.getExtensionFor(name);
        display = name.replace(extension, '');
        id = this.nextId();
        documentModel = new CodeSync.Document({
          name: name,
          extension: extension,
          display: display,
          path: path,
          id: id
        });
        return documentModel.loadSourceFromDisk(function() {
          return typeof callback === "function" ? callback(documentModel) : void 0;
        });
      }
    }
  });

  helpers = {
    processStyleContent: function(content) {
      $('head style[data-codesync-document]').remove();
      return $('head').append("<style type='text/css' data-codesync-document=true>" + content + "</style>");
    },
    processScriptContent: function(code) {
      var doc, evalRunner;
      doc = this;
      evalRunner = function(code) {
        try {
          return eval(code);
        } catch (e) {
          doc.trigger("status", {
            type: "error",
            message: "JS Error: " + e.message,
            sticky: true
          });
          throw e;
        }
      };
      return evalRunner.call(window, code);
    }
  };

}).call(this);
