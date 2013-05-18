(function() {

  CodeSync.Gist = Backbone.Model.extend({
    initialize: function(attributes) {
      this.attributes = attributes != null ? attributes : {};
    },
    url: function() {},
    toDocuments: function() {}
  });

}).call(this);
