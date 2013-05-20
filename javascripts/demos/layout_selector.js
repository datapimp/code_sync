(function() {

  window.LayoutSelector = Backbone.View.extend({
    id: "layout-selector",
    tagName: "ul",
    events: {
      "click .opt1": function() {
        return $('.editor-container').attr('data-layout', 'one');
      },
      "click .opt2": function() {
        return $('.editor-container').attr('data-layout', 'two');
      },
      "click .opt3": function() {
        return $('.editor-container').attr('data-layout', 'three');
      }
    },
    render: function() {
      var n, _i, _len, _ref;
      _ref = [1, 2, 3];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        n = _ref[_i];
        this.$el.append("<li class='opt" + n + "'>" + n + "</li>");
      }
      return this;
    }
  });

}).call(this);
