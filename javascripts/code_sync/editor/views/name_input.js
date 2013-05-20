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
