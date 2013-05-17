(function() {

  this.Skim = {
    access: function(name) {
      var value;
      value = this[name];
      if (typeof value === "function") {
        value = value.call(this);
      }
      if (value === true) {
        return [this];
      }
      if (value === false || !(value != null)) {
        return false;
      }
      if (Object.prototype.toString.call(value) !== "[object Array]") {
        return [value];
      }
      if (value.length === 0) {
        return false;
      }
      return value;
    },
    withContext: function(context, block) {
      var create;
      create = function(o) {
        var F;
        F = function() {};
        F.prototype = o;
        return new F;
      };
      context = create(context);
      context.safe || (context.safe = this.safe || function(value) {
        var result;
        if (value != null ? value.skimSafe : void 0) {
          return value;
        }
        result = new String(value != null ? value : '');
        result.skimSafe = true;
        return result;
      });
      context.escape || (context.escape = this.escape || function(string) {
        if (string == null) {
          return '';
        }
        if (string.skimSafe) {
          return string;
        }
        return this.safe(('' + string).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/\//g, '&#47;'));
      });
      return block.call(context);
    }
  };

}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/asset_editor"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"codesync-asset-editor\"><div class=\"toolbar-wrapper\"></div><div class=\"mode-selector-wrapper\"></div></div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/asset_selector"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"asset-selector-wrapper\"><div class=\"search-input\"><input placeholder=\"Type the name of an asset to open it\" type=\"text\" /></div><div class=\"search-results-wrapper\"><div class=\"search-results\"></div></div></div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/document_manager_tab"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var classes, closable, displayValue, _buf, _ref, _ref1, _ref2, _temple_coffeescript_attributeremover1, _temple_coffeescript_attributeremover2;
        _buf = [];
        displayValue = this.display || this.doc.get("display") || this.doc.get("name");
        if ((this.doc != null) && this.doc.isSticky()) {
          closable = true;
        }
        classes = ["document-tab"];
        if (this.cls != null) {
          classes.push(this.cls);
        }
        if (this.doc != null) {
          classes.push("selectable");
        }
        if (!((_ref = this.doc) != null ? _ref.isSticky() : void 0)) {
          classes.push("closable");
        }
        if (this.index !== 0) {
          classes.push("hideable");
        }
        if ((this.doc != null) && !((_ref1 = this.doc) != null ? _ref1.isSticky() : void 0)) {
          classes.push("editable");
        }
        _buf.push("<div");
        _temple_coffeescript_attributeremover1 = [];
        _temple_coffeescript_attributeremover1.push(this.escape(classes.join(' ')));
        _temple_coffeescript_attributeremover1.join('');
        if (_temple_coffeescript_attributeremover1.length > 0) {
          _buf.push(" class=\"");
          _buf.push(_temple_coffeescript_attributeremover1);
          _buf.push("\"");
        }
        _temple_coffeescript_attributeremover2 = [];
        _temple_coffeescript_attributeremover2.push(this.escape((_ref2 = this.doc) != null ? _ref2.cid : void 0));
        _temple_coffeescript_attributeremover2.join('');
        if (_temple_coffeescript_attributeremover2.length > 0) {
          _buf.push(" data-document-cid=\"");
          _buf.push(_temple_coffeescript_attributeremover2);
          _buf.push("\"");
        }
        _buf.push("><div class=\"contents\">");
        _buf.push(this.escape(displayValue));
        _buf.push("</div>");
        if (closable) {
          _buf.push("<div class=\"close-anchor\"><X></X></div>");
        }
        _buf.push("</div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/preferences_panel"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf, _temple_coffeescript_attributeremover1, _temple_coffeescript_attributeremover2;
        _buf = [];
        _buf.push("<form><div class=\"control-group\"><label>KeyBindings</label><div class=\"controls\"><select name=\"keyMap\"><option value=\"default\">Default</option><option value=\"vim\">Vim</option></select></div></div><div class=\"control-group\"><label>Theme</label><div class=\"controls\"><select name=\"theme\"><option value=\"ambiance\">Ambiance</option><option value=\"lesser-dark\">Lesser Dark</option><option value=\"monokai\">Monokai</option><option value=\"xq-light\">XQ Light</option></select></div></div><div class=\"control-group\"><label>Asset Compiler Endpoint</label><div class=\"controls\"><input name=\"asset_endpoint\" type=\"text\"");
        _temple_coffeescript_attributeremover1 = [];
        _temple_coffeescript_attributeremover1.push(this.escape(CodeSync.get('assetCompilationEndpoint')));
        _temple_coffeescript_attributeremover1.join('');
        if (_temple_coffeescript_attributeremover1.length > 0) {
          _buf.push(" value=\"");
          _buf.push(_temple_coffeescript_attributeremover1);
          _buf.push("\"");
        }
        _buf.push(" /></div></div><div class=\"control-group\"><label>Hotkey</label><div class=\"controls\"><input name=\"editor_hotkey\" type=\"text\"");
        _temple_coffeescript_attributeremover2 = [];
        _temple_coffeescript_attributeremover2.push(this.escape(CodeSync.get('editorToggleHotkey')));
        _temple_coffeescript_attributeremover2.join('');
        if (_temple_coffeescript_attributeremover2.length > 0) {
          _buf.push(" value=\"");
          _buf.push(_temple_coffeescript_attributeremover2);
          _buf.push("\"");
        }
        _buf.push(" /></div></div><div class=\"control-group\"><label>Position</label><div class=\"controls\"><select name=\"position\"><option value=\"top\">Top</option><option value=\"bottom\">Bottom</option></select></div></div></form>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
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
      codeMirrorOptions: {
        indentUnit: 2,
        smartIndent: true,
        tabSize: 2,
        indentWithTabs: false
      },
      defaultContent: "# You are currently in Coffeescript Mode\n#\n# Any coffeescript you type in here will be evaluated.\n#\n# defining this function will allow you to respond\n# to code and template changes that happen in this editor.\n#\n#\n# CodeSync.onScriptChange = (changeObject)->\n#   console.log \"Detected new code from CodeSync\", changeObject\n#\n#"
    },
    sass: {
      name: "Sass",
      extension: ".css.sass",
      defaultContent: "// You are currently in Sass mode.",
      codeMirrorOptions: {
        indentUnit: 2,
        smartIndent: true,
        tabSize: 2,
        indentWithTabs: false
      }
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
      template: true,
      codeMirrorOptions: {
        indentUnit: 2,
        smartIndent: true,
        tabSize: 2,
        indentWithTabs: false
      }
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
(function() {

  CodeSync.ProjectAssets = Backbone.Collection.extend({
    url: function() {
      return CodeSync.get("serverInfoEndpoint");
    },
    parse: function(response) {
      var description, models, path;
      models = (function() {
        var _i, _len, _ref, _results;
        _ref = _.uniq(response.project_assets);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          path = _ref[_i];
          description = path.replace(response.root, '');
          _results.push({
            path: path,
            description: description
          });
        }
        return _results;
      })();
      return models;
    },
    initialize: function() {
      this.fetch();
      return Backbone.Collection.prototype.initialize.apply(this, arguments);
    }
  });

}).call(this);
(function() {

  CodeSync.AssetSelector = Backbone.View.extend({
    className: "codesync-asset-selector",
    events: {
      "keyup input": "keyHandler",
      "click .search-result": "selectSearchResult"
    },
    initialize: function(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      Backbone.View.prototype.initialize.apply(this, arguments);
      this.editor = options.editor;
      _.bindAll(this, "keyHandler", "loadAsset");
      this.selected = new Backbone.Model({
        index: -1
      });
      return this.selected.on("change:index", function(model, value) {
        _this.$('.search-result').removeClass('active');
        return _this.$('.search-result').eq(value).addClass('active');
      });
    },
    keyHandler: function(e) {
      switch (e.keyCode) {
        case 13:
          return this.openCurrentSearchResult();
        case 27:
          return this.hide();
        case 38:
          return this.previousSearchResult();
        case 40:
          return this.nextSearchResult();
        default:
          return this.filterAssetsBy(this.$('input').val());
      }
    },
    openCurrentSearchResult: function() {
      var asset, index,
        _this = this;
      index = this.selected.attributes.index;
      if (asset = this.searchResults[index]) {
        this.selected.set('index', 0, {
          silent: true
        });
        _.delay(function() {
          return _this.loadAsset(_this.searchResults[index].get('path'));
        }, 10);
        return this.hide();
      }
    },
    previousSearchResult: function() {
      var index;
      index = this.selected.attributes.index;
      index -= 1;
      if (index < 0) {
        index = 0;
      }
      return this.selected.set({
        index: index
      });
    },
    nextSearchResult: function() {
      var index;
      index = this.selected.attributes.index;
      index += 1;
      if (index > this.searchResults.length) {
        index = 0;
      }
      return this.selected.set({
        index: index
      });
    },
    selectSearchResult: function(e) {
      var _ref;
      return this.loadAsset((_ref = $(e.target)) != null ? _ref.data('path') : void 0);
    },
    loadAsset: function(path) {
      return this.trigger("asset:selected", path);
    },
    filterAssetsBy: function(value) {
      var index, model, wrapper, _i, _len, _ref;
      if (value.length <= 1) {
        return;
      }
      wrapper = this.showSearchResults();
      wrapper.empty();
      this.selected.set('index', -1, {
        silent: true
      });
      this.searchResults = this.collection.select(function(model) {
        var regex, _ref, _ref1;
        regex = new RegExp("" + value);
        return ((_ref = model.get("description")) != null ? _ref.match(regex) : void 0) || ((_ref1 = model.get("path")) != null ? _ref1.match(regex) : void 0);
      });
      this.searchResults = this.searchResults.slice(0, 5);
      _ref = this.searchResults;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        model = _ref[index];
        wrapper.append("<div data-path='" + (model.get('path')) + "' class='search-result'>" + (model.get('description')) + "</div>");
      }
      return wrapper.height(this.searchResults.length * 40);
    },
    showSearchResults: function() {
      return this.wrapper.show();
    },
    hideSearchResults: function() {
      return this.wrapper.hide();
    },
    toggle: function() {
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    },
    show: function() {
      this.wrapper.empty();
      this.visible = true;
      this.$el.show();
      this.hideSearchResults();
      return this.$('input').val('').focus();
    },
    hide: function() {
      this.$el.hide();
      this.visible = false;
      return this.editor.codeMirror.focus();
    },
    render: function() {
      this.$el.html(JST["code_sync/editor/templates/asset_selector"]());
      this.wrapper || (this.wrapper = this.$('.search-results-wrapper'));
      return this;
    }
  });

}).call(this);
(function() {

  CodeSync.plugins.ColorPicker = Backbone.View.extend({
    className: "codesync-color-picker",
    spectrumOptions: {
      showAlpha: true,
      preferredFormat: "hex6",
      flat: true,
      showInput: true,
      chooseText: "Choose"
    },
    initialize: function(options) {
      this.options = options != null ? options : {};
      _.extend(this, this.options);
      this.$el.append("<input type='color' class='color-picker-widget' />");
      return this.widget = this.$('.color-picker-widget');
    },
    remove: function() {
      this.widget.spectrum("destroy");
      return this.$el.remove();
    },
    hide: function() {
      this.widget.spectrum("hide");
      return this.$el.hide();
    },
    show: function() {
      this.widget.spectrum("show");
      return this.$el.show();
    },
    render: function() {
      this.widget.spectrum(this.spectrumOptions);
      return this;
    }
  });

}).call(this);
(function() {

  CodeSync.plugins.DocumentManager = Backbone.View.extend({
    views: {},
    events: {
      "click .document-tab.selectable": "onDocumentTabSelection",
      "click .document-tab.closable .close-anchor": "closeTab",
      "click .document-tab.new-document": "createDocument",
      "click .document-tab.save-document": "saveDocument",
      "click .document-tab.open-document": "toggleAssetSelector",
      "dblclick .document-tab.editable": "onDoubleClickTab",
      "blur .document-tab.editable .contents": "onEditableTabBlur",
      "keydown .document-tab.editable .contents": "onEditableTabKeyPress"
    },
    initialize: function(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      this.editor = options.editor;
      this.$el.append("<div class='document-tabs-container' />");
      this.openDocuments = new CodeSync.Documents();
      this.openDocuments.on("add", this.renderTabs, this);
      this.openDocuments.on("remove", this.renderTabs, this);
      this.openDocuments.on("change:display", this.renderTabs, this);
      this.projectAssets = new CodeSync.ProjectAssets();
      this.state = new Backbone.Model({
        currentDocument: void 0
      });
      this.state.on("change:currentDocument", this.highlightActiveDocumentTab, this);
      this.on("editor:hidden", function() {
        return _this.$('.document-tab.hideable').hide();
      });
      this.on("editor:visible", function() {
        _this.$('.document-tab.hideable').show();
        return _this.toggleSaveButton();
      });
      this.views.assetSelector = new CodeSync.AssetSelector({
        collection: this.projectAssets,
        documents: this.openDocuments,
        editor: this.editor
      });
      return this.views.assetSelector.on("asset:selected", this.onAssetSelection, this);
    },
    documentInTab: function(tabElement) {
      var cid, doc;
      if (!tabElement.is('.document-tab')) {
        tabElement = tabElement.parents('.document-tab').eq(0);
      }
      if (cid = tabElement.data('document-cid')) {
        return doc = this.openDocuments.detect(function(model) {
          return model.cid === cid;
        });
      }
    },
    renderTabs: function() {
      var container, tmpl;
      container = this.$('.document-tabs-container').empty();
      tmpl = JST["code_sync/editor/templates/document_manager_tab"];
      this.openDocuments.each(function(doc, index) {
        return container.append(tmpl({
          doc: doc,
          index: index
        }));
      });
      container.append(tmpl({
        display: "New",
        cls: "new-document"
      }));
      return container.append(tmpl({
        display: "Open",
        cls: "open-document"
      }));
    },
    onAssetSelection: function(path) {
      var _this = this;
      return this.openDocuments.findOrCreateForPath(path, function(doc) {
        return _this.openDocument(doc);
      });
    },
    onEditableTabKeyPress: function(e) {
      var contents, doc, original, target;
      target = this.$(e.target).closest('.document-tab');
      contents = target.children('.contents');
      if (e.keyCode === 13 || e.keyCode === 27) {
        e.preventDefault();
        contents.attr('contenteditable', false);
        if (doc = this.documentInTab(target)) {
          if (e.keyCode === 13) {
            doc.set('name', contents.html());
          }
          if (e.keyCode === 27 && (original = target.attr('data-original-value'))) {
            contents.html(original);
          }
        }
        return this.editor.codeMirror.focus();
      }
    },
    onEditableTabBlur: function(e) {
      var contents, doc, target, _ref;
      target = this.$(e.target).closest('.document-tab');
      contents = target.children('.contents');
      console.log("On Editable Tab Blur", (_ref = this.documentInTab(target)) != null ? _ref.cid : void 0);
      if (doc = this.documentInTab(target)) {
        doc.set('name', contents.html());
        return contents.attr('contenteditable', false);
      }
    },
    onDoubleClickTab: function(e) {
      var contents, target;
      target = this.$(e.target).closest('.document-tab');
      contents = target.children('.contents');
      target.attr('data-original-value', contents.html());
      return contents.attr('contenteditable', true);
    },
    onDocumentTabSelection: function(e) {
      var doc, target;
      this.trigger("tab:click");
      target = this.$(e.target).closest('.document-tab');
      doc = this.documentInTab(target);
      return this.setCurrentDocument(doc);
    },
    closeTab: function(e) {
      var doc, index, target;
      target = this.$(e.target);
      doc = this.documentInTab(target);
      index = this.openDocuments.indexOf(doc);
      this.openDocuments.remove(doc);
      return this.setCurrentDocument(this.openDocuments.at(index - 1) || this.openDocuments.at(0));
    },
    getCurrentDocument: function() {
      return this.currentDocument;
    },
    openDocument: function(doc) {
      this.openDocuments.add(doc);
      return this.setCurrentDocument(doc);
    },
    setCurrentDocument: function(currentDocument) {
      this.currentDocument = currentDocument;
      return this.editor.loadDocument(this.currentDocument);
    },
    toggleSaveButton: function() {
      var _ref, _ref1;
      if (((_ref = this.currentDocument) != null ? (_ref1 = _ref.get("path")) != null ? _ref1.length : void 0 : void 0) > 0) {
        return this.$('.save-document').show();
      } else {
        return this.$('.save-document').hide();
      }
    },
    saveDocument: function() {
      if (CodeSync.get("disableAssetSave")) {
        return this.editor.showStatusMessage({
          type: "error",
          message: "Saving is disabled in this demo."
        });
      } else {
        return this.currentDocument.saveToDisk();
      }
    },
    createDocument: function() {
      var doc;
      this.openDocuments.add({
        name: "untitled",
        display: "Untitled",
        mode: CodeSync.get("defaultFileType"),
        extension: CodeSync.Modes.guessExtensionFor(CodeSync.get("defaultFileType"))
      });
      doc = this.openDocuments.last();
      return this.openDocument(doc);
    },
    toggleAssetSelector: function() {
      return this.views.assetSelector.toggle();
    },
    render: function() {
      this.$el.append(this.views.assetSelector.render().el);
      return this;
    }
  });

  CodeSync.plugins.DocumentManager.setup = function(editor) {
    var dm,
      _this = this;
    dm = this.views.documentManager = new CodeSync.plugins.DocumentManager({
      editor: this
    });
    _.extend(editor.codeMirrorKeyBindings, {
      "Ctrl-T": function() {
        return dm.toggleAssetSelector();
      },
      "Ctrl-S": function() {
        return dm.getCurrentDocument().save();
      },
      "Ctrl-N": function() {
        return dm.createDocument();
      }
    });
    this.$el.append(dm.render().el);
    dm.on("tab:click", function() {
      if (_this.visible === false) {
        return _this.show();
      }
    });
    return CodeSync.AssetEditor.prototype.loadDefaultDocument = function() {
      var defaultDocument;
      defaultDocument = editor.getDefaultDocument();
      return dm.openDocument(defaultDocument);
    };
  };

}).call(this);
(function() {

  CodeSync.plugins.KeymapSelector = Backbone.View.extend({
    className: "keymap-selector",
    events: {
      "change select": "onSelect"
    },
    initialize: function(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      this.editor = options.editor;
      this.editor.on("change:keymap", function(keyMap) {
        return _this.setValue(keyMap);
      });
      return Backbone.View.prototype.initialize.apply(this, arguments);
    },
    onSelect: function() {
      var selected;
      selected = this.$('select').val();
      return this.editor.setKeyMap(selected);
    },
    setValue: function(val) {
      return this.$('select').val(val);
    },
    render: function() {
      var mode, options, _i, _len, _ref;
      options = "";
      _ref = ["default", "vim"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mode = _ref[_i];
        options += "<option value='" + mode + "'>" + mode + "</option>";
      }
      this.$el.html("<select>" + options + "</select>");
      return this;
    }
  });

  CodeSync.plugins.KeymapSelector.setup = function(editor) {
    var v;
    v = this.views.keymapSelector = new CodeSync.plugins.KeymapSelector({
      editor: editor
    });
    return editor.$('.codesync-asset-editor').append(v.render().el);
  };

}).call(this);
(function() {

  CodeSync.plugins.ModeSelector = Backbone.View.extend({
    className: "mode-selector",
    events: {
      "change select": "onSelect"
    },
    initialize: function(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      this.editor = options.editor;
      this.modes = this.editor.modes;
      this.modes.on("reset", this.render, this);
      this.editor.on("change:mode", function(modeModel, modeId) {
        return _this.setValue(modeId);
      });
      return Backbone.View.prototype.initialize.apply(this, arguments);
    },
    onSelect: function() {
      var mode, selected;
      selected = this.$('select').val();
      mode = this.modes.get(selected);
      return this.editor.setMode(mode);
    },
    setValue: function(val) {
      return this.$('select').val(val);
    },
    render: function() {
      var mode, options, _i, _len, _ref;
      options = "";
      _ref = this.modes.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mode = _ref[_i];
        options += "<option value='" + mode.id + "'>" + (mode.get('name')) + "</option>";
      }
      this.$el.html("<select>" + options + "</select>");
      return this;
    }
  });

  CodeSync.plugins.ModeSelector.setup = function(editor) {
    var v;
    v = this.views.modeSelector = new CodeSync.plugins.ModeSelector({
      editor: editor
    });
    editor.$('.codesync-asset-editor').append(v.render().el);
    return editor.on("document:loaded", function(doc) {
      return v.setValue(doc.get('mode'));
    });
  };

}).call(this);
(function() {

  CodeSync.NameInput = Backbone.View.extend({
    className: "asset-name-input",
    events: {
      "change input": "updateEditor",
      "keyup input": "updateEditor",
      "blur input": "toggle"
    },
    initialize: function(options) {
      if (options == null) {
        options = {};
      }
      this.editor = options.editor;
      _.bindAll(this, "_updateEditor", "updateEditor", "toggle");
      this._updateEditor = _.debounce(CodeSync.NameInput.prototype._updateEditor, 300);
      return Backbone.View.prototype.initialize.apply(this, arguments);
    },
    render: function() {
      this.$el.append("<input type='text' placeholder='Enter the name of the asset' />");
      this.$el.hide();
      return this;
    },
    updateEditor: function() {
      return this._updateEditor();
    },
    _updateEditor: function() {
      var assetName, mode;
      assetName = this.$('input').val();
      if (assetName.match(/\./)) {
        this.editor.currentName = assetName;
        return mode = this.editor.determineModeFor(assetName);
      }
    },
    setValue: function(value) {
      return this.$('input').val(value);
    },
    getValue: function() {
      return this.$('input').val();
    },
    toggle: function() {
      var _ref;
      if (((_ref = this.getValue()) != null ? _ref.length : void 0) === 0) {
        this.editor.setDefaultExtension();
        this.editor.currentName = this.editor.currentPath = void 0;
      }
      return this.$el.toggle();
    }
  });

}).call(this);
(function() {

  CodeSync.plugins.PreferencesPanel = Backbone.View.extend({
    className: "preferences-panel",
    events: {
      "change select,input": function() {
        return this.trigger("update:preferences");
      }
    },
    renderHidden: true,
    initialize: function(options) {
      this.editor = options.editor;
      this.$el.html(JST["code_sync/editor/templates/preferences_panel"]());
      return Backbone.View.prototype.initialize.apply(this, arguments);
    },
    values: function() {
      var el, input, values, _i, _len, _ref;
      values = {};
      _ref = this.$('input,select');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        input = $(el);
        values[input.attr('name')] = input.val();
      }
      return values;
    },
    toggle: function() {
      this.syncWithEditorOptions();
      return this.$el.toggle();
    },
    syncWithEditorOptions: function() {
      this.$('select[name="theme"]').val(this.editor.codeMirror.getOption('theme'));
      this.$('select[name="keyMap"]').val(this.editor.codeMirror.getOption('keyMap'));
      this.$('input[name="asset_endpoint"]').val(CodeSync.get("assetCompilationEndpoint"));
      return this.$('input[name="editor_hotkey"]').val(CodeSync.get("editorToggleHotKey"));
    },
    render: function() {
      if (this.renderHidden === true) {
        this.$el.hide();
      }
      return this;
    }
  });

  CodeSync.plugins.PreferencesPanel.setup = function(editor) {
    var panel,
      _this = this;
    panel = new CodeSync.plugins.PreferencesPanel({
      editor: this
    });
    this.$('.toolbar-wrapper').append("<div class='button toggle-preferences'>Preferences</div>");
    this.events["click .toggle-preferences"] = function() {
      return panel.toggle();
    };
    this.$el.append(panel.render().el);
    panel.on("update:preferences", function() {
      var values;
      values = panel.values();
      editor.setTheme(values.theme);
      editor.setKeyMap(values.keyMap);
      CodeSync.set("assetCompilationEndpoint", values.asset_endpoint);
      return CodeSync.AssetEditor.setHotKey(values.editor_hotkey);
    });
    editor.on("codemirror:setup", function(cm) {
      return cm.on("focus", function() {
        return panel.$el.hide();
      });
    });
    return panel.on("update:preferences", function() {
      var values;
      values = panel.values();
      if (editor.position !== values.position) {
        return editor.setPosition(values.position);
      }
    });
  };

}).call(this);
(function() {

  CodeSync.AssetEditor = Backbone.View.extend({
    className: "codesync-editor",
    autoRender: true,
    autoAppend: true,
    appendTo: "body",
    renderVisible: true,
    position: "top",
    effect: "slide",
    effectDuration: 400,
    editorChangeThrottle: 800,
    visible: false,
    showVisibleTab: true,
    hideable: true,
    startMode: "scss",
    theme: "ambiance",
    keyBindings: "",
    events: {
      "click .status-message": "removeStatusMessages",
      "click .hide-button": "hide"
    },
    plugins: ["DocumentManager", "ModeSelector", "PreferencesPanel"],
    initialize: function(options) {
      var _this = this;
      this.options = options != null ? options : {};
      _.extend(this, this.options);
      _.bindAll(this, "editorChangeHandler");
      this.views = {};
      this.modes = CodeSync.Modes.get();
      this.startMode = this.modes.get(this.startMode) || CodeSync.Modes.defaultMode();
      this.setPosition(this.position, false);
      this.on("editor:change", _.debounce(this.editorChangeHandler, this.editorChangeThrottle), this);
      this.on("codemirror:setup", function() {
        return _this.loadDefaultDocument();
      });
      this.$el.html(JST["code_sync/editor/templates/asset_editor"]());
      this.loadPlugins();
      if (this.autoRender !== false) {
        return this.render();
      }
    },
    loadPlugins: function() {
      var PluginClass, plugin, _i, _len, _ref, _results;
      _ref = this.plugins;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        plugin = _ref[_i];
        if (!(CodeSync.plugins[plugin] != null)) {
          continue;
        }
        PluginClass = CodeSync.plugins[plugin];
        _results.push(PluginClass.setup.call(this, this));
      }
      return _results;
    },
    render: function() {
      var _this = this;
      if (this.rendered === true) {
        return this;
      }
      this.setupToolbar();
      this.delegateEvents();
      this.rendered = true;
      if (this.autoAppend === true) {
        $(this.appendTo).prepend(this.el);
      }
      if (this.renderHidden === true) {
        this.show();
        setTimeout(function() {
          return _this.hide();
        }, 900);
      }
      if (this.renderVisible === true) {
        this.show();
      }
      return this;
    },
    setupCodeMirror: function() {
      var changeHandler,
        _this = this;
      if (this.codeMirror != null) {
        return;
      }
      this.height || (this.height = this.$el.height());
      this.codeMirror = CodeMirror(this.$('.codesync-asset-editor')[0], this.getCodeMirrorOptions());
      this.on("initial:document:load", function() {
        if (_this.startMode) {
          _this.setMode(_this.startMode);
        }
        if (_this.keyBindings) {
          _this.setKeyMap(_this.keyBindings);
        }
        if (_this.theme || (_this.theme = localStorage.getItem("codesync:theme"))) {
          return _this.setTheme(_this.theme);
        }
      });
      changeHandler = function(changeObj) {
        return _this.trigger("editor:change", _this.codeMirror.getValue(), changeObj);
      };
      this.codeMirror.on("change", _.debounce(changeHandler, this.editorChangeThrottle));
      this.trigger("codemirror:setup", this.codeMirror);
      return this;
    },
    codeMirrorKeyBindings: {
      "Ctrl-J": function() {
        return this.toggle();
      }
    },
    getCodeMirrorOptions: function() {
      var handler, keyCommand, options, _ref, _ref1;
      _ref = this.codeMirrorKeyBindings;
      for (keyCommand in _ref) {
        handler = _ref[keyCommand];
        this.codeMirrorKeyBindings[keyCommand] = _.bind(handler, this);
      }
      return options = {
        theme: 'lesser-dark',
        lineNumbers: true,
        mode: ((_ref1 = this.startMode) != null ? _ref1.get("codeMirrorMode") : void 0) || CodeSync.get("defaultFileType"),
        extraKeys: this.codeMirrorKeyBindings
      };
    },
    editorChangeHandler: function(editorContents) {
      return this.currentDocument.set("contents", editorContents);
    },
    setPosition: function(position, show) {
      var available, _i, _len, _ref;
      this.position = position != null ? position : "top";
      if (show == null) {
        show = true;
      }
      _ref = ["top", "bottom", "static"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        available = _ref[_i];
        if (available !== this.position) {
          this.$el.removeClass("" + available + "-positioned");
        }
      }
      this.$el.addClass("" + this.position + "-positioned");
      if (show === true) {
        this.show();
      }
      return this;
    },
    setKeyMap: function(keyMap) {
      return this.codeMirror.setOption('keyMap', keyMap);
    },
    setTheme: function(theme) {
      this.theme = theme;
      this.$el.attr("data-theme", this.theme);
      return this.codeMirror.setOption('theme', this.theme);
    },
    setMode: function(newMode) {
      var _ref;
      if ((this.mode != null) && (newMode !== this.mode)) {
        this.trigger("change:mode", newMode, newMode.id);
      }
      this.mode = newMode;
      if (((_ref = this.mode) != null ? _ref.get : void 0) != null) {
        this.codeMirror.setOption('mode', this.mode.get("codeMirrorMode"));
        this.currentDocument.set('mode', this.mode.id);
        this.currentDocument.set('extension', CodeSync.Modes.guessExtensionFor(this.mode.id));
      }
      return this;
    },
    setupToolbar: function() {
      if (this.hideable === true) {
        return this.$('.toolbar-wrapper').append("<div class='button hide-button'>Hide</div>");
      }
    },
    getDefaultDocument: function() {
      var defaultDocument, defaultOptions, options;
      defaultOptions = {
        mode: this.options.startMode || CodeSync.get("defaultFileType"),
        sticky: true,
        doNotSave: true,
        name: this.defaultDocumentName || "codesync",
        display: "CodeSync Editor"
      };
      options = _.extend(defaultOptions, this.document);
      return defaultDocument = new CodeSync.Document(options);
    },
    loadDefaultDocument: function() {
      return this.loadDocument(this.getDefaultDocument());
    },
    loadDocument: function(doc) {
      if (this.currentDocument != null) {
        this.currentDocument.off("status", this.showStatusMessage);
        this.currentDocument.off("change:compiled", this.applyDocumentContentToPage);
        this.currentDocument.off("change:mode", this.applyDocumentContentToPage, this);
      } else {
        this.currentDocument = doc;
        this.trigger("initial:document:load");
      }
      this.currentDocument = doc;
      this.trigger("document:loaded", doc);
      this.codeMirror.swapDoc(this.currentDocument.toCodeMirrorDocument());
      this.currentDocument.on("status", this.showStatusMessage, this);
      this.currentDocument.on("change:compiled", this.applyDocumentContentToPage, this);
      this.currentDocument.on("change:mode", this.applyDocumentContentToPage, this);
      return this.currentDocument.on;
    },
    applyDocumentContentToPage: function() {
      var _ref,
        _this = this;
      if ((this.currentDocument != null) && (this.currentDocument.toMode() !== this.mode)) {
        this.setMode(this.currentDocument.toMode());
      }
      return (_ref = this.currentDocument) != null ? _ref.loadInPage({
        complete: function() {
          var _ref1, _ref2;
          if (_this.currentDocument.type() === "script" || _this.currentDocument.type() === "template") {
            if ((_ref1 = CodeSync.onScriptChange) != null) {
              _ref1.call(window, _this.currentDocument.attributes);
            }
          }
          if (_this.currentDocument.type() === "stylesheet") {
            return (_ref2 = CodeSync.onStylesheetChange) != null ? _ref2.call(window, _this.currentDocument.attributes) : void 0;
          }
        }
      }) : void 0;
    },
    removeStatusMessages: function() {
      return this.$('.status-message').remove();
    },
    showStatusMessage: function(options) {
      var _ref,
        _this = this;
      if (options == null) {
        options = {};
      }
      this.removeStatusMessages();
      if (((_ref = options.message) != null ? _ref.length : void 0) > 0) {
        this.$el.prepend("<div class='status-message " + options.type + "'>" + options.message + "</div>");
      }
      if (options.type === "success") {
        return _.delay(function() {
          return _this.$('.status-message.success').animate({
            opacity: 0
          }, {
            duration: 400,
            complete: function() {
              return _this.$('.status-message.success').remove();
            }
          });
        }, 1200);
      }
    },
    hintHeight: function() {
      var offset;
      return offset = this.showVisibleTab ? this.$('.document-tabs-container').height() : 0;
    },
    visibleStyleSettings: function() {
      var settings;
      if (this.position === "static") {
        settings = {};
      }
      if (this.position === "top") {
        settings = {
          top: '0px',
          bottom: 'auto'
        };
      }
      if (this.position === "bottom") {
        settings = {
          top: 'auto',
          bottom: '0px',
          height: '400px'
        };
      }
      return settings;
    },
    hiddenStyleSettings: function() {
      var settings;
      if (this.position === "static") {
        settings = {};
      }
      if (this.position === "top") {
        settings = {
          top: ((this.$el.height() + 8) * -1) + this.hintHeight(),
          bottom: 'auto'
        };
      }
      if (this.position === "bottom") {
        settings = {
          top: 'auto',
          bottom: '0px',
          height: "" + (this.hintHeight() - 8) + "px"
        };
      }
      return settings;
    },
    hide: function(withEffect) {
      var completeFn, view, viewName, _ref,
        _this = this;
      if (withEffect == null) {
        withEffect = true;
      }
      this.animating = true;
      _ref = this.views;
      for (viewName in _ref) {
        view = _ref[viewName];
        view.trigger("editor:hidden");
      }
      completeFn = _.debounce(function() {
        _this.visible = false;
        return _this.animating = false;
      }, this.effectDuration + 20);
      if (withEffect !== false) {
        this.$el.animate(this.hiddenStyleSettings(), {
          duration: this.effectDuration,
          complete: completeFn
        });
        _.delay(completeFn, this.effectDuration);
      } else {
        completeFn();
      }
      return this;
    },
    show: function(withEffect) {
      var completeFn, view, viewName, _ref,
        _this = this;
      if (withEffect == null) {
        withEffect = true;
      }
      this.setupCodeMirror();
      this.animating = true;
      _ref = this.views;
      for (viewName in _ref) {
        view = _ref[viewName];
        view.trigger("editor:visible");
      }
      completeFn = _.debounce(function() {
        _this.visible = true;
        return _this.animating = false;
      }, this.effectDuration);
      if (withEffect !== false) {
        this.$el.animate(this.visibleStyleSettings(), {
          duration: this.effectDuration,
          complete: completeFn
        });
        _.delay(completeFn, this.effectDuration);
      } else {
        completeFn();
      }
      return this;
    },
    toggle: function() {
      if (this.animating === true) {
        return;
      }
      if (this.visible === true) {
        return this.hide(true);
      } else {
        return this.show(true);
      }
    }
  });

  CodeSync.AssetEditor.keyboardShortcutInfo = "ctrl+j: toggle editor ctrl+t: open asset";

  CodeSync.AssetEditor.toggleEditor = _.debounce(function(options) {
    if (options == null) {
      options = {};
    }
    if (window.codeSyncEditor != null) {
      return window.codeSyncEditor.toggle();
    } else {
      window.codeSyncEditor = new CodeSync.AssetEditor(options);
      $('body').prepend(window.codeSyncEditor.render().el);
      return window.codeSyncEditor.show();
    }
  }, 1);

  CodeSync.AssetEditor.setHotKey = function(hotKey, options) {
    if (options == null) {
      options = {};
    }
    CodeSync.set("editorToggleHotkey", hotKey);
    return key(hotKey, function() {
      return CodeSync.AssetEditor.toggleEditor(options);
    });
  };

}).call(this);
