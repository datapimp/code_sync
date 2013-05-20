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
