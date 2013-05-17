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
