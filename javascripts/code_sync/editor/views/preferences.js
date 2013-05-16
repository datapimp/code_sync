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
