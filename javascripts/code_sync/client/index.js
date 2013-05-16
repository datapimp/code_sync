(function() {
  var sourceEval;

  CodeSync.Client = (function() {

    Client._clients = [];

    Client.get = function() {
      return CodeSync.Client._clients[0];
    };

    Client.prototype.VERSION = CodeSync.VERSION;

    Client.prototype.logLevel = 0;

    function Client(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      this.logLevel = options.logLevel || 0;
      CodeSync.Client._clients.push(this);
      CodeSync.util.loadScript("" + (CodeSync.get("socketEndpoint")) + "/client.js", function() {
        if (_this.clientLoaded === true) {
          return;
        }
        setTimeout(function() {
          try {
            return _this.setupSocket();
          } catch (e) {
            return console.log("Error setting up codesync client");
          }
        }, 25);
        return _this.clientLoaded = true;
      });
    }

    Client.prototype.setupSocket = function() {
      var _this = this;
      if (typeof Faye === "undefined" || Faye === null) {
        return;
      }
      this.socket = new Faye.Client(CodeSync.get("socketEndpoint"));
      return this.socket.subscribe("/code-sync/outbound", function(notification) {
        var _ref, _ref1, _ref2;
        console.log("notification", notification);
        if (_this.logLevel > 0) {
          console.log("Received notification on outbound channel", notification);
        }
        if ((_ref = _this.onNotification) != null) {
          if (typeof _ref.call === "function") {
            _ref.call(_this, notification);
          }
        }
        if ((_ref1 = notification.name) != null ? _ref1.match(/\.js$/) : void 0) {
          _this.onJavascriptNotification.call(_this, notification);
        }
        if ((_ref2 = notification.name) != null ? _ref2.match(/\.css$/) : void 0) {
          return _this.onStylesheetNotification.call(_this, notification);
        }
      });
    };

    Client.prototype.javascriptCallbacks = [];

    Client.prototype.stylesheetCallbacks = [];

    Client.prototype.removeJavascriptCallbacks = function() {
      return this.javascriptCallbacks = [];
    };

    Client.prototype.removeStylesheetCallbacks = function() {
      return this.stylesheetCalbacks = [];
    };

    Client.prototype.afterJavascriptChange = function(callback, clearExisting) {
      if (clearExisting == null) {
        clearExisting = false;
      }
      this.javascriptCallbacks || (this.javascriptCallbacks = []);
      if (clearExisting === true) {
        this.javascriptCallbacks = [];
      }
      return this.javascriptCallbacks.push(callback);
    };

    Client.prototype.afterStylesheetChange = function(callback, clearExisting) {
      if (clearExisting == null) {
        clearExisting = false;
      }
      this.stylesheetCallbacks || (this.stylesheetCallbacks = []);
      if (clearExisting === true) {
        this.stylesheetCallbacks = [];
      }
      return this.stylesheetCallbacks.push(callback);
    };

    Client.prototype.onJavascriptNotification = function(notification) {
      var callback, client, _i, _len, _ref;
      client = this;
      CodeSync.processing = true;
      if (notification.source) {
        sourceEval.call(window, notification.source);
        _ref = client.javascriptCallbacks;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          callback = _ref[_i];
          if (callback.call != null) {
            callback.call(client, notification);
          }
        }
        CodeSync.processing = false;
        return;
      }
      if (notification.path) {
        console.log("notification", notification.path);
        return CodeSync.util.loadScript("" + (CodeSync.get("sprocketsEndpoint")) + "/" + notification.path, function() {
          var _j, _len1, _ref1, _results;
          _ref1 = client.javascriptCallbacks;
          _results = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            callback = _ref1[_j];
            if (callback.call != null) {
              _results.push(callback.call(this, notification));
            }
          }
          return _results;
        });
      }
    };

    Client.prototype.onStylesheetNotification = function(notification) {
      var client;
      client = this;
      if (notification.path && notification.name) {
        return CodeSync.util.loadStylesheet("" + (CodeSync.get("sprocketsEndpoint")) + "/" + notification.path, {
          tracker: notification.name
        }, function() {
          var callback, _i, _len, _ref, _results;
          _ref = client.stylesheetCallbacks;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            callback = _ref[_i];
            if (callback.call != null) {
              _results.push(callback.call(this, notification));
            }
          }
          return _results;
        });
      }
    };

    return Client;

  })();

  sourceEval = function(source) {
    return eval(source);
  };

}).call(this);
(function() {
  var loadedScripts, scriptTimers;

  CodeSync.util || (CodeSync.util = {});

  loadedScripts = {};

  scriptTimers = {};

  CodeSync.util.loadStylesheet = function(url, options, callback) {
    var ss;
    if (options == null) {
      options = {};
    }
    ss = document.createElement("link");
    ss.type = "text/css";
    ss.rel = "stylesheet";
    ss.href = url;
    ss.className = "code-sync-asset";
    if (options.tracker) {
      $("link[data-tracker='" + options.tracker + "']").remove();
      ss.setAttribute("data-tracker", options.tracker);
    }
    document.getElementsByTagName("head")[0].appendChild(ss);
    return callback != null ? typeof callback.call === "function" ? callback.call(this) : void 0 : void 0;
  };

  CodeSync.util.loadScript = function(url, options, callback) {
    var head, loaded, onLoad, script, that, timers;
    if (options == null) {
      options = {};
    }
    loaded = loadedScripts;
    timers = scriptTimers;
    if (typeof options === "function" && !(callback != null)) {
      callback = options;
      options = {};
    }
    head = document.getElementsByTagName('head')[0];
    script = document.createElement("script");
    script.src = url;
    script.type = "text/javascript";
    that = this;
    onLoad = function() {
      if (typeof callback === "function") {
        callback.call(that, url, options, script);
      }
      try {
        head.removeChild(script);
      } catch (e) {
        true;
      }
      return loaded[url] = true;
    };
    if (options.once === true && loaded[url]) {
      return false;
    }
    head.appendChild(script);
    script.onreadystatechange = function() {
      if (script.readyState === "loaded" || script.readyState === "complete") {
        return onLoad();
      }
    };
    script.onload = onLoad;
    if (typeof navigator !== "undefined" && navigator !== null ? navigator.userAgent.match(/WebKit/) : void 0) {
      return timers[url] = setInterval(function() {
        onLoad();
        return clearInterval(timers[url]);
      }, 10);
    }
  };

}).call(this);
