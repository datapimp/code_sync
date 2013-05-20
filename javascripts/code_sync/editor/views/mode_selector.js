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
