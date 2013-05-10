this.Skim = {
  access: function(name) {
    var value;
    value = this[name];
    if (typeof value === "function") {
      value = value.call(this);
    }
    if (value === true) {
      return [this];
    }
    if (value === false || !(value != null)) {
      return false;
    }
    if (Object.prototype.toString.call(value) !== "[object Array]") {
      return [value];
    }
    if (value.length === 0) {
      return false;
    }
    return value;
  },
  withContext: function(context, block) {
    var create;
    create = function(o) {
      var F;
      F = function() {};
      F.prototype = o;
      return new F;
    };
    context = create(context);
    context.safe || (context.safe = this.safe || function(value) {
      var result;
      if (value != null ? value.skimSafe : void 0) {
        return value;
      }
      result = new String(value != null ? value : '');
      result.skimSafe = true;
      return result;
    });
    context.escape || (context.escape = this.escape || function(string) {
      if (string == null) {
        return '';
      }
      if (string.skimSafe) {
        return string;
      }
      return this.safe(('' + string).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/\//g, '&#47;'));
    });
    return block.call(context);
  }
};

(function() { this.JST || (this.JST = {}); this.JST["code_sync/templates/asset_editor"] = (function() {

    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"codesync-editor-wrapper\"><div class=\"asset-save-controls\"><div class='preferences-wrapper'><input type='button' class='toggle-preferences' value='Preferences' /></div><div class='file-options-wrapper'><input class=\"open-button\" type=\"button\" value=\"Open\" /><input class=\"save-button\" type=\"button\" value=\"Save\" /></div><div class='clearfix'></div></div><div class=\"codesync-asset-editor\"></div><div class='keyboard-shortcut-info'>Keyboard Shortcut Info</div></div>");
        return _buf.join('');
      });
    };

  }).call(this);;
}).call(this);

(function() { this.JST || (this.JST = {}); this.JST["code_sync/templates/asset_selector"] = (function() {

    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"asset-selector-wrapper\"><div class=\"search-input\"><input placeholder=\"type the name of an asset to edit it\" type=\"text\" /></div><div class=\"search-results-wrapper\"><div class=\"search-results\"></div></div></div>");
        return _buf.join('');
      });
    };

  }).call(this);;
}).call(this);
