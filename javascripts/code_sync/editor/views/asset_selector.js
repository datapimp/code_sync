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
