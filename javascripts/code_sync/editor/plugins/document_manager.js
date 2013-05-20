(function() {

  CodeSync.plugins.DocumentManager = Backbone.View.extend({
    className: "codesync-document-manager",
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
      this.options = options != null ? options : {};
      _.extend(this, options);
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
      var container, tmpl,
        _this = this;
      container = this.$('.document-tabs-container').empty();
      tmpl = JST["code_sync/editor/templates/document_manager_tab"];
      this.openDocuments.each(function(doc, index) {
        if (!(_this.skipTabForDefault === true && index === 0)) {
          return container.append(tmpl({
            doc: doc,
            index: index
          }));
        }
      });
      if (this.allowNew !== false) {
        container.append(tmpl({
          display: "New",
          cls: "new-document"
        }));
      }
      if (this.allowOpen !== false) {
        return container.append(tmpl({
          display: "Open",
          cls: "open-document"
        }));
      }
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
    openDocument: function(doc, editor) {
      editor || (editor = this.editor);
      this.openDocuments.add(doc);
      return this.setCurrentDocument(doc, editor);
    },
    setCurrentDocument: function(currentDocument, editor) {
      this.currentDocument = currentDocument;
      editor || (editor = this.editor);
      return editor.loadDocument(this.currentDocument);
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

  CodeSync.plugins.DocumentManager.setup = function(editor, options) {
    var dm,
      _this = this;
    if (options == null) {
      options = {};
    }
    options.editor = editor;
    dm = this.views.documentManager = new CodeSync.plugins.DocumentManager(options);
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
