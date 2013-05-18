(function() {

  CodeSync.plugins.ColorPicker = Backbone.View.extend({
    className: "codesync-color-picker",
    spectrumOptions: {
      showAlpha: false,
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
      this.$el.hide();
      return this.off("color:change");
    },
    show: function() {
      this.widget.spectrum("show");
      return this.$el.show();
    },
    syncWithToken: function(token, cursor) {
      var cm, endch, line, startch,
        _this = this;
      cm = this.editor.codeMirror;
      cm.addWidget(cursor, this.el);
      this.show();
      line = cm.getLine(cursor.line);
      startch = token.start;
      endch = token.end;
      this.widget.spectrum("set", token.string);
      return this.on("color:change", _.debounce(function(colorObject, hexValue) {
        var _ref;
        cm.replaceRange("#" + hexValue, {
          line: cursor.line,
          ch: startch
        }, {
          line: cursor.line,
          ch: endch
        });
        return (_ref = _this.editor.currentDocument) != null ? _ref.trigger("change:contents") : void 0;
      }));
    },
    render: function() {
      var opts,
        _this = this;
      opts = _.extend(this.spectrumOptions, {
        move: _.debounce(function(color) {
          return _this.trigger("color:change", color, color.toHex());
        }, 200)
      });
      this.widget.spectrum(this.spectrumOptions);
      return this;
    }
  });

  CodeSync.plugins.ColorPicker.setup = function(editor) {
    var cm;
    this.colorPicker = new CodeSync.plugins.ColorPicker({
      editor: editor
    });
    this.$el.append(editor.colorPicker.render().el);
    this.colorPicker.hide();
    cm = editor.codeMirror;
    return cm.on("cursorActivity", function() {
      var cursor, token, _ref, _ref1;
      cursor = cm.getCursor();
      token = cm.getTokenAt(cursor);
      if (((_ref = token.string) != null ? _ref.match(/#[a-fA-F0-9]{3,6}/g) : void 0) && ((_ref1 = token.string) != null ? _ref1.length : void 0) >= 6) {
        return editor.colorPicker.syncWithToken(token, cursor);
      } else {
        return editor.colorPicker.hide();
      }
    });
  };

}).call(this);
