//     keymaster.js
//     (c) 2011-2012 Thomas Fuchs
//     keymaster.js may be freely distributed under the MIT license.
(function(a){function b(a,b){var c=a.length;while(c--)if(a[c]===b)return c;return-1}function c(a,c){var d,e,g,h,i;d=a.keyCode,b(u,d)==-1&&u.push(d);if(d==93||d==224)d=91;if(d in q){q[d]=!0;for(g in s)s[g]==d&&(f[g]=!0);return}if(!f.filter.call(this,a))return;if(!(d in p))return;for(h=0;h<p[d].length;h++){e=p[d][h];if(e.scope==c||e.scope=="all"){i=e.mods.length>0;for(g in q)if(!q[g]&&b(e.mods,+g)>-1||q[g]&&b(e.mods,+g)==-1)i=!1;(e.mods.length==0&&!q[16]&&!q[18]&&!q[17]&&!q[91]||i)&&e.method(a,e)===!1&&(a.preventDefault?a.preventDefault():a.returnValue=!1,a.stopPropagation&&a.stopPropagation(),a.cancelBubble&&(a.cancelBubble=!0))}}}function d(a){var c=a.keyCode,d,e=b(u,c);e>=0&&u.splice(e,1);if(c==93||c==224)c=91;if(c in q){q[c]=!1;for(d in s)s[d]==c&&(f[d]=!1)}}function e(){for(o in q)q[o]=!1;for(o in s)f[o]=!1}function f(a,b,c){var d,e,f,g;c===undefined&&(c=b,b="all"),a=a.replace(/\s/g,""),d=a.split(","),d[d.length-1]==""&&(d[d.length-2]+=",");for(f=0;f<d.length;f++){e=[],a=d[f].split("+");if(a.length>1){e=a.slice(0,a.length-1);for(g=0;g<e.length;g++)e[g]=s[e[g]];a=[a[a.length-1]]}a=a[0],a=t[a]||a.toUpperCase().charCodeAt(0),a in p||(p[a]=[]),p[a].push({shortcut:d[f],scope:b,method:c,key:d[f],mods:e})}}function g(a){if(typeof a=="string"){if(a.length!=1)return!1;a=a.toUpperCase().charCodeAt(0)}return b(u,a)!=-1}function h(){return u}function i(a){var b=(a.target||a.srcElement).tagName;return b!="INPUT"&&b!="SELECT"&&b!="TEXTAREA"}function j(a){r=a||"all"}function k(){return r||"all"}function l(a){var b,c,d;for(b in p){c=p[b];for(d=0;d<c.length;)c[d].scope===a?c.splice(d,1):d++}}function m(a,b,c){a.addEventListener?a.addEventListener(b,c,!1):a.attachEvent&&a.attachEvent("on"+b,function(){c(window.event)})}function n(){var b=a.key;return a.key=v,b}var o,p={},q={16:!1,18:!1,17:!1,91:!1},r="all",s={"⇧":16,shift:16,"⌥":18,alt:18,option:18,"⌃":17,ctrl:17,control:17,"⌘":91,command:91},t={backspace:8,tab:9,clear:12,enter:13,"return":13,esc:27,escape:27,space:32,left:37,up:38,right:39,down:40,del:46,"delete":46,home:36,end:35,pageup:33,pagedown:34,",":188,".":190,"/":191,"`":192,"-":189,"=":187,";":186,"'":222,"[":219,"]":221,"\\":220},u=[];for(o=1;o<20;o++)s["f"+o]=111+o;for(o in s)f[o]=!1;m(document,"keydown",function(a){c(a,r)}),m(document,"keyup",d),m(window,"focus",e);var v=a.key;a.key=f,a.key.setScope=j,a.key.getScope=k,a.key.deleteScope=l,a.key.filter=i,a.key.isPressed=g,a.key.getPressedKeyCodes=h,a.key.noConflict=n,typeof module!="undefined"&&(module.exports=key)})(this),function(){var a;window.KeyLauncher||(window.KeyLauncher={}),(a=window.KeyLauncher).loaders||(a.loaders={}),window.loadedScripts={},window.scriptTimers={},KeyLauncher.loaders.stylesheet=function(a,b,c){var d;return b==null&&(b={}),d=document.createElement("link"),d.type="text/css",d.rel="stylesheet",d.href=a,document.getElementsByTagName("head")[0].appendChild(d),c.call(this)},KeyLauncher.loaders.script=function(a,b,c){var d,e,f,g,h,i;b==null&&(b={}),e=loadedScripts,i=scriptTimers,typeof b=="function"&&c==null&&(c=b,b={}),d=document.getElementsByTagName("head")[0],g=document.createElement("script"),g.src=a,g.type="text/javascript",h=this,f=function(){typeof c=="function"&&c.call(h,a,b,g);try{d.removeChild(g)}catch(f){!0}return e[a]=!0};if(b.once===!0&&e[a])return!1;d.appendChild(g),g.onreadystatechange=function(){if(g.readyState==="loaded"||g.readyState==="complete")return f()},g.onload=f;if(typeof navigator!="undefined"&&navigator!==null?navigator.userAgent.match(/WebKit/):void 0)return i[a]=setInterval(function(){return f(),clearInterval(i[a])},10)}}.call(this),function(){window.KeyLauncher.Launcher=function(){function Launcher(a){var b,c,d;this.options=a!=null?a:{},this.fn=a.fn,this.before=a.before,this.command=a.command,d=this.options.requires;for(b in d)c=d[b],this._dependencies[c]={loaded:!1,provides:b}}return Launcher.prototype._dependencies={},Launcher.prototype.run=function(){var state,type,url,_ref,_ref1,_results,_this=this;this.ran=!1,(_ref=this.before)!=null&&typeof _ref.call=="function"&&_ref.call(this);if(this.isReady())return this.onReady();_ref1=this._dependencies,_results=[];for(url in _ref1){state=_ref1[url];try{state.loaded=eval(state.provides)!=null}catch(e){state.loaded=!1}state.loaded!==!0?(type=url.match(/\.css/)?"stylesheet":"script",_results.push(KeyLauncher.loaders[type](url,function(a){return _this.onDependencyLoad(a)}))):_results.push(void 0)}return _results},Launcher.prototype.requires=function(a){return this._dependencies[a]={loaded:!1}},Launcher.prototype.isReady=function(){var a,b,c,d;b=!0,d=this._dependencies;for(a in d)c=d[a],c.loaded===!1&&(b=!1);return b},Launcher.prototype.onDependencyLoad=function(a){this._dependencies[a].loaded=!0;if(this.isReady())return this.onReady()},Launcher.prototype.onReady=function(){var a=this;if(!this.isReady()||this.ran!==!1)return;return function(){return a.fn.call(a),a.ran=!0}()},Launcher}()}.call(this),function(){var a;KeyLauncher.VERSION="0.0.4",KeyLauncher.on=function(a,b,c){var d;c==null&&(c={});if(a==null)throw"Must specify a valid key command";return d=new KeyLauncher.Launcher({command:a,fn:b||function(){},before:c.before,requires:c.requires||[]}),key(a,function(){return d.run.call(d)}),d},a=function(a,b){var c,d,e,f,g;f=KeyLauncher.currentSequence||"",g=b.shortcut,KeyLauncher.currentSequence=""+f+g,e=function(){var a,b;a=KeyLauncher.sequences,b=[];for(c in a)d=a[c],c.match(KeyLauncher.currentSequence)&&b.push(c);return b}(),e.length>0||(KeyLauncher.currentSequence="");if(e.length===1&&(d=KeyLauncher.sequences[KeyLauncher.currentSequence]))return d.run.call(d),KeyLauncher.currentSequence=""},KeyLauncher.onSequence=function(b,c,d){var e,f,g,h,i;d==null&&(d={}),KeyLauncher.sequences||(KeyLauncher.sequences={}),f=KeyLauncher.sequences[b]=new KeyLauncher.Launcher({fn:c||function(){},requires:d.requires||[],before:d.before}),i=b.split("");for(g=0,h=i.length;g<h;g++)e=i[g],key(e,a);return f}}.call(this);
(function() {
  var CodeSync, root;

  root = this;

  if (typeof exports !== "undefined") {
    CodeSync = exports;
  } else {
    CodeSync = root.CodeSync = {};
  }

  CodeSync.VERSION = "0.6.0";

  CodeSync.backends = {};

  CodeSync.util = {};

  CodeSync.plugins = {};

  CodeSync._config || (CodeSync._config = {
    defaultFileType: "coffeescript",
    assetCompilationEndpoint: "http://localhost:9295/source",
    serverInfoEndpoint: "http://localhost:9295/info",
    sprocketsEndpoint: "http://localhost:9295/assets",
    socketEndpoint: "http://localhost:9295/faye"
  });

  CodeSync.set = function(setting, value) {
    return CodeSync._config[setting] = value;
  };

  CodeSync.get = function(setting) {
    return CodeSync._config[setting];
  };

}).call(this);
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
(function() {

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

}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/asset_editor"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"codesync-editor-wrapper\"><div class=\"codesync-asset-editor\"></div><div class=\"preferences-panel\" style=\"display:none\"></div><div class=\"mode-selector-wrapper\"></div></div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/asset_selector"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"asset-selector-wrapper\"><div class=\"search-input\"><input placeholder=\"Type the name of an asset to open it\" type=\"text\" /></div><div class=\"search-results-wrapper\"><div class=\"search-results\"></div></div></div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() {
  var helpers,
    __slice = [].slice;

  CodeSync.Document = Backbone.Model.extend({
    callbackDelay: 150,
    initialize: function(attributes, options) {
      var _this = this;
      this.attributes = attributes;
      Backbone.Model.prototype.initialize.apply(this, arguments);
      this.on("change:contents", this.process, this);
      this.on("change:name", function() {
        return _this.set("mode", _this.determineMode(), {
          silent: false
        });
      });
      return this.on("change:mode", function() {
        return _this.set('extension', _this.determineExtension(), {
          silent: true
        });
      });
    },
    url: function() {
      return CodeSync.get("assetCompilationEndpoint");
    },
    saveToDisk: function() {
      var _ref, _ref1;
      console.log("Document Save To Disk", this.get("path"), (_ref = this.get("path")) != null ? _ref.length : void 0);
      if (((_ref1 = this.get("path")) != null ? _ref1.length : void 0) > 0) {
        return this.process(true, "Save To Disk");
      }
    },
    loadSourceFromDisk: function(callback) {
      var _this = this;
      return $.ajax({
        url: "" + (this.url()) + "?path=" + (this.get('path')),
        type: "GET",
        success: function(response) {
          if (response == null) {
            response = {};
          }
          if (response.success === true && (response.contents != null)) {
            _this.set("contents", response.contents, {
              silent: true
            });
            return callback(_this);
          }
        }
      });
    },
    applyDefaults: function() {
      return this.attributes = _.defaults(this.attributes, {
        name: "untitled",
        mode: this.determineMode() || CodeSync.get("defaultFileType"),
        extension: this.determineExtension(),
        compiled: "",
        display: "Untitled",
        contents: "//"
      });
    },
    toJSON: function() {
      return {
        name: this.get('name'),
        path: this.get('path'),
        extension: this.get('extension'),
        contents: this.get('contents')
      };
    },
    toCodeMirrorDocument: function() {
      return CodeMirror.Doc("" + (this.get("contents") || ''), this.get("mode"), 0);
    },
    process: function(allowSaveToDisk) {
      var data,
        _this = this;
      if (allowSaveToDisk == null) {
        allowSaveToDisk = false;
      }
      data = allowSaveToDisk === true ? this.toJSON() : _(this.toJSON()).pick('name', 'extension', 'contents');
      console.log("Process", arguments, data);
      return $.ajax({
        type: "POST",
        url: CodeSync.get("assetCompilationEndpoint"),
        data: JSON.stringify(data),
        success: function(response) {
          var _ref, _ref1;
          console.log("Process Response", response);
          if (response.success === true) {
            _this.trigger("status", {
              type: "success",
              message: "Success"
            });
          }
          if (response.success === true && (response.compiled != null)) {
            _this.set("compiled", response.compiled);
          }
          if (response.success === false && (response.error != null)) {
            _this.set("error", (_ref = response.error) != null ? _ref.message : void 0);
            return _this.trigger("status", {
              type: "error",
              message: (_ref1 = response.error) != null ? _ref1.message : void 0
            });
          }
        }
      });
    },
    loadInPage: function(options) {
      if (options == null) {
        options = {};
      }
      if (this.type() === "stylesheet") {
        return helpers.processStyleContent.call(this, this.get('compiled'));
      } else if (this.type() === "script") {
        helpers.processScriptContent.call(this, this.get('compiled'));
        if (options.complete) {
          return _.delay(options.complete, options.delay || this.callbackDelay);
        }
      }
    },
    type: function() {
      switch (this.get("mode")) {
        case "css":
        case "sass":
        case "scss":
        case "less":
          return "stylesheet";
        case "coffeescript":
        case "javascript":
        case "skim":
        case "mustache":
        case "jst":
        case "haml":
        case "eco":
          return "script";
      }
    },
    missingFileName: function() {
      var name;
      name = this.get('path') || this.get('name');
      return !(name != null) || name.length === 0;
    },
    determineExtension: function() {
      var extension, filename;
      filename = this.get("path") || this.get("name");
      if (extension = CodeSync.Document.getExtensionFor(filename)) {
        return extension;
      }
      if (this.get("mode") != null) {
        return CodeSync.Modes.guessExtensionFor(this.get('mode') || CodeSync.get("defaultFileType"));
      }
    },
    determineMode: function() {
      var path;
      path = this.get("path") || this.get("name") || this.get("extension");
      return CodeSync.Modes.guessModeFor(path);
    }
  });

  CodeSync.Document.getFileNameFrom = function(string) {
    if (string == null) {
      string = "";
    }
    return string.split('/').pop();
  };

  CodeSync.Document.getExtensionFor = function(string) {
    var filename, fname, rest, val, _ref;
    if (string == null) {
      string = "";
    }
    filename = CodeSync.Document.getFileNameFrom(string);
    _ref = filename.split('.'), fname = _ref[0], rest = 2 <= _ref.length ? __slice.call(_ref, 1) : [];
    if (val = rest.length > 0 && rest.join('.')) {
      return "." + val;
    }
  };

  CodeSync.Documents = Backbone.Collection.extend({
    model: CodeSync.Document,
    nextId: function() {
      return this.models.length + 1;
    },
    findOrCreateForPath: function(path, callback) {
      var display, documentModel, extension, id, name,
        _this = this;
      if (path == null) {
        path = "";
      }
      documentModel = this.detect(function(documentModel) {
        var _ref;
        return (_ref = documentModel.get('path')) != null ? _ref.match(path) : void 0;
      });
      if (documentModel != null) {
        return typeof callback === "function" ? callback(documentModel) : void 0;
      } else {
        name = CodeSync.Document.getFileNameFrom(path);
        extension = CodeSync.Document.getExtensionFor(name);
        display = name.replace(extension, '');
        id = this.nextId();
        documentModel = new CodeSync.Document({
          name: name,
          extension: extension,
          display: display,
          path: path,
          id: id
        });
        documentModel.applyDefaults();
        return documentModel.loadSourceFromDisk(function() {
          _this.add(documentModel);
          return typeof callback === "function" ? callback(documentModel) : void 0;
        });
      }
    }
  });

  helpers = {
    processStyleContent: function(content) {
      $('head style[data-codesync-document]').remove();
      return $('head').append("<style type='text/css' data-codesync-document=true>" + content + "</style>");
    },
    processScriptContent: function(code) {
      var evalRunner;
      evalRunner = function(code) {
        return eval(code);
      };
      return evalRunner.call(window, code);
    }
  };

}).call(this);
(function() {
  var modes;

  CodeSync.Modes = Backbone.Collection.extend({
    initialize: function(models, options) {
      var attributes, key, value;
      if (models == null) {
        models = [];
      }
      if (options == null) {
        options = {};
      }
      models = (function() {
        var _results;
        _results = [];
        for (key in modes) {
          value = modes[key];
          _results.push(attributes = {
            id: key,
            name: value.name || key,
            codeMirrorMode: value.codeMirrorMode || key,
            extension: value.extension,
            extensionRegex: new RegExp("" + value.extension)
          });
        }
        return _results;
      })();
      Backbone.Collection.prototype.initialize.apply(this, arguments);
      return this.reset(models, {
        silent: true
      });
    },
    findModeFor: function(pathOrFilename) {
      var mode,
        _this = this;
      if (pathOrFilename == null) {
        pathOrFilename = "";
      }
      if (!pathOrFilename.match(/\./)) {
        pathOrFilename = "." + pathOrFilename;
      }
      mode = this.detect(function(model) {
        var regex;
        regex = model.get("extensionRegex");
        return regex.exec(pathOrFilename);
      });
      return mode != null ? mode.get("codeMirrorMode") : void 0;
    },
    findExtensionFor: function(mode) {
      mode = this.detect(function(model) {
        return model.get('codeMirrorMode') === mode || model.get('id') === mode;
      });
      return mode != null ? mode.get("extension") : void 0;
    },
    defaultMode: function() {
      var defaultFileType, _ref;
      defaultFileType = CodeSync.get("defaultFileType");
      return (_ref = this.get(defaultFileType)) != null ? _ref.get("codeMirrorMode") : void 0;
    }
  });

  CodeSync.Modes.guessModeFor = function(pathOrFilename) {
    return CodeSync.Modes.get().findModeFor(pathOrFilename);
  };

  CodeSync.Modes.guessExtensionFor = function(mode) {
    return CodeSync.Modes.get().findExtensionFor(mode);
  };

  CodeSync.Modes.get = function() {
    var _base;
    return (_base = CodeSync.Modes).singleton || (_base.singleton = new CodeSync.Modes());
  };

  modes = {
    coffeescript: {
      extension: ".coffee"
    },
    sass: {
      name: "Sass",
      extension: ".css.sass"
    },
    scss: {
      codeMirrorMode: "css",
      extension: ".css.scss"
    },
    skim: {
      extension: ".jst.skim"
    },
    css: {
      name: "CSS",
      extension: ".css"
    },
    javascript: {
      name: "Javascript",
      extension: ".js"
    }
  };

}).call(this);
(function() {

  CodeSync.ProjectAssets = Backbone.Collection.extend({
    url: function() {
      return CodeSync.get("serverInfoEndpoint");
    },
    parse: function(response) {
      var description, models, path;
      models = (function() {
        var _i, _len, _ref, _results;
        _ref = _.uniq(response.project_assets);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          path = _ref[_i];
          description = path.replace(response.root, '');
          _results.push({
            path: path,
            description: description
          });
        }
        return _results;
      })();
      return models;
    },
    initialize: function() {
      this.fetch();
      return Backbone.Collection.prototype.initialize.apply(this, arguments);
    }
  });

}).call(this);
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
(function() {

  CodeSync.plugins.DocumentManager = Backbone.View.extend({
    views: {},
    events: {
      "click .document-tab.selectable": "onDocumentTabSelection",
      "click .document-tab.closable .close-anchor": "closeTab",
      "click .document-tab.new-document": "createDocument",
      "click .document-tab.save-document": "saveDocument",
      "click .document-tab.open-document": "toggleAssetSelector",
      "dblclick .document-tab.selectable": "onDoubleClickTab",
      "blur .document-tab.editable .contents": "onEditableTabBlur",
      "keypress .document-tab.editable .contents": "onEditableTabKeyPress"
    },
    initialize: function(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      this.editor = options.editor;
      this.$el.append("<div class='document-tabs-container' />");
      this.openDocuments = new CodeSync.Documents();
      this.openDocuments.on("add", this.renderTabs, this);
      this.openDocuments.on("remove", this.renderTabs, this);
      this.openDocuments.on("change:display", this.renderTabs, this);
      this.projectAssets = new CodeSync.ProjectAssets();
      this.state = new Backbone.Model({
        currentDocument: void 0
      });
      this.state.on("change:currentDocument", this.highlightActiveDocumentTab, this);
      this.on("editor:hidden", function() {
        return _this.$('.document-tab.hideable').hide();
      });
      this.on("editor:visible", function() {
        _this.$('.document-tab.hideable').show();
        return _this.toggleSaveButton();
      });
      this.views.assetSelector = new CodeSync.AssetSelector({
        collection: this.projectAssets,
        documents: this.openDocuments,
        editor: this.editor
      });
      return this.views.assetSelector.on("asset:selected", this.onAssetSelection, this);
    },
    renderTabs: function() {
      var closeAnchor, cls, container, documentModel, index, _i, _len, _ref;
      container = this.$('.document-tabs-container').empty();
      _ref = this.openDocuments.models;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        documentModel = _ref[index];
        cls = "";
        closeAnchor = "";
        if (documentModel.id !== 1) {
          cls = 'closable hideable';
          closeAnchor = "<small class='close-anchor'>x</small>";
        }
        container.append("<div class='document-tab selectable " + cls + "' data-document-id='" + documentModel.id + "' data-document-index='" + index + "'><span class='contents'>" + (documentModel.get('display')) + "</span> " + closeAnchor + "</div>");
      }
      container.append("<div class='document-tab static new-document hideable'>New</div>");
      if (CodeSync.get("disableAssetOpen") !== true) {
        container.append("<div class='document-tab static open-document hideable'>Open</div>");
      }
      container.append("<div class='document-tab static save-document hideable'>Save</div>");
      return this;
    },
    onAssetSelection: function(path) {
      var _this = this;
      return this.openDocuments.findOrCreateForPath(path, function(documentModel) {
        return _this.loadDocument(documentModel);
      });
    },
    onEditableTabKeyPress: function(e) {
      var content, documentModel, target;
      target = this.$(e.target).closest('.document-tab');
      content = this.$('.contents', target);
      if (e.keyCode === 13) {
        e.preventDefault();
        target.removeClass('editable');
        content.attr('contenteditable', false);
        if (documentModel = this.openDocuments.at(target.data('document-index'))) {
          documentModel.set('name', content.html());
        }
        return this.editor.codeMirror.focus();
      }
    },
    onEditableTabBlur: function(e) {
      var content, documentModel, target;
      target = this.$(e.target).closest('.document-tab');
      content = this.$('.contents', target);
      if (documentModel = this.openDocuments.at(target.data('document-index'))) {
        documentModel.set('name', content.html());
        return content.attr('contenteditable', false);
      }
    },
    onDoubleClickTab: function(e) {
      var documentModel, target;
      target = this.$(e.target).closest('.document-tab');
      target.addClass('editable');
      if (documentModel = this.openDocuments.at(target.data('document-index'))) {
        this.loadDocument(documentModel);
      }
      return this.$('.contents', target).attr('contenteditable', true);
    },
    onDocumentTabSelection: function(e) {
      var documentModel, target;
      this.trigger("tab:click");
      target = this.$(e.target).closest('.document-tab');
      documentModel = this.openDocuments.at(target.data('document-index'));
      return this.loadDocument(documentModel);
    },
    closeTab: function(e) {
      var documentModel, index, target;
      target = this.$(e.target).closest('.document-tab');
      index = target.data('document-index');
      documentModel = this.openDocuments.at(index);
      this.openDocuments.remove(documentModel);
      return this.loadDocument(this.openDocuments.at(index - 1) || this.openDocuments.at(0));
    },
    getCurrentDocument: function() {
      return this.currentDocument;
    },
    loadDocument: function(documentModel) {
      this.currentDocument = documentModel;
      this.trigger("document:loaded", documentModel);
      return this.toggleSaveButton();
    },
    toggleSaveButton: function() {
      var _ref, _ref1;
      if (((_ref = this.currentDocument) != null ? (_ref1 = _ref.get("path")) != null ? _ref1.length : void 0 : void 0) > 0) {
        return this.$('.save-document').show();
      } else {
        return this.$('.save-document').hide();
      }
    },
    saveDocument: function() {
      if (CodeSync.get("disableAssetSave")) {
        return this.editor.showStatusMessage({
          type: "error",
          message: "Saving is disabled in this demo."
        });
      } else {
        return this.currentDocument.saveToDisk();
      }
    },
    createDocument: function() {
      var documentModel;
      this.openDocuments.add({
        name: "untitled",
        display: "Untitled",
        mode: CodeSync.get("defaultFileType"),
        extension: CodeSync.Modes.guessExtensionFor(CodeSync.get("defaultFileType"))
      });
      documentModel = this.openDocuments.last();
      return this.loadDocument(documentModel);
    },
    createAdHocDocument: function() {
      this.openDocuments.add({
        id: 1,
        extension: ".css.sass",
        name: "scratch-pad",
        mode: "sass",
        path: void 0,
        display: "CodeSync Editor",
        contents: "// Feel free to experiment with Sass"
      });
      return this.openDocuments.get(1);
    },
    toggleAssetSelector: function() {
      return this.views.assetSelector.toggle();
    },
    render: function() {
      this.loadDocument(this.createAdHocDocument());
      this.$el.append(this.views.assetSelector.render().el);
      return this;
    }
  });

  CodeSync.plugins.DocumentManager.setup = function(editor) {
    var dm,
      _this = this;
    dm = this.views.documentManager = new CodeSync.plugins.DocumentManager({
      editor: this
    });
    _.extend(editor.codeMirrorKeyBindings, {
      "Ctrl-T": function() {
        return dm.toggleAssetSelector();
      },
      "Ctrl-S": function() {
        return dm.getCurrentDocument().save();
      },
      "Ctrl-N": function() {
        return dm.createDocument();
      }
    });
    this.$el.append(dm.render().el);
    this.on("codemirror:setup", this.loadAdhocDocument, this);
    dm.on("tab:click", function() {
      if (_this.visible === false) {
        return _this.show();
      }
    });
    return dm.on("document:loaded", editor.onDocumentLoad, this);
  };

}).call(this);
(function() {

  CodeSync.plugins.ModeSelector = Backbone.View.extend({
    className: "mode-selector",
    events: {
      "change select": "onSelect"
    },
    initialize: function(options) {
      if (options == null) {
        options = {};
      }
      this.modes = CodeSync.Modes.get();
      this.modes.on("reset", this.render, this);
      this.editor = options.editor;
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
    editor.$el.append(v.render().el);
    return editor.on("document:loaded", function(doc) {
      return v.setValue(doc.get('mode'));
    });
  };

}).call(this);
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
(function() {
  var markup;

  CodeSync.PreferencesPanel = Backbone.View.extend({
    className: "preferences-panel",
    events: {
      "change :input": "updateEditor"
    },
    initialize: function(options) {
      this.editor = options.editor;
      _.bindAll(this, "updateEditor");
      this.$el.html(markup);
      this.$("input[name='asset-url']").val(this.editor.assetCompilationEndpoint);
      return Backbone.View.prototype.initialize.apply(this, arguments);
    },
    updateEditor: function() {
      var values;
      values = this.values();
      this.editor.assetCompilationEndpoint = values["asset-url"];
      this.editor.setTheme(values.theme);
      this.editor.setKeyMap(values.keyMap);
      return this.editor.setMode(values.mode);
    },
    setDefaultExtension: function(values) {
      return this.editor.setDefaultExtension();
    },
    syncWithEditorOptions: function() {
      this.$(":input[name='keyMap']").val(this.editor.codeMirror.getOption('keyMap'));
      this.$(":input[name='mode']").val(this.editor.codeMirror.getOption('mode'));
      this.$(":input[name='theme']").val(this.editor.codeMirror.getOption('theme'));
      return this.$(":input[name='asset-url']").val(this.editor.assetCompilationEndpoint);
    },
    values: function() {
      var el, input, values, _i, _len, _ref;
      values = {};
      _ref = this.$(':input');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        input = $(el);
        values[input.attr('name')] = input.val();
      }
      return values;
    },
    toggle: function() {
      this.syncWithEditorOptions();
      return this.$el.toggle();
    },
    render: function() {
      this.$el.hide();
      return this;
    }
  });

  markup = "<div class='mode-selector control-group'>\n  <label>Mode</label>\n  <div class='controls'>\n    <select name=\"mode\">\n      <option value=\"coffeescript\">Coffeescript</option>\n      <option value=\"css\">CSS</option>\n      <option value=\"haml\">Haml</option>\n      <option value=\"htmlmixed\">HTML</option>\n      <option value=\"javascript\">Javascript</option>\n      <option value=\"markdown\">Markdown</option>\n      <option value=\"sass\">Sass</option>\n      <option value=\"css\">SCSS</option>\n      <option value=\"skim\">Skim</option>\n      <option value=\"ruby\">Ruby</option>\n    </select>\n  </div>\n</div>\n<div class=\"keymap-selector control-group\">\n  <label>Keybindings</label>\n  <select name=\"keyMap\">\n    <option value=\"default\">Default</option>\n    <option value=\"vim\">Vim</option>\n  </select>\n</div>\n<div class=\"theme-selector control-group\">\n  <label>Theme</label>\n  <div class='controls'>\n    <select name=\"theme\">\n      <option value=\"ambiance\">Ambiance</option>\n      <option value=\"lesser-dark\">Lesser Dark</option>\n      <option value=\"monokai\">Monokai</option>\n      <option value=\"xq-light\">XQ Light</option>\n    </select>\n  </div>\n</div>\n<div class=\"asset-compilation-endpoint control-group\">\n  <label>Asset Compilation URL</label>\n  <input type=\"text\" name=\"asset-url\" />\n</div>";

}).call(this);
(function() {

  CodeSync.AssetEditor = Backbone.View.extend({
    className: "codesync-editor",
    autoRender: true,
    position: "top",
    effect: "slide",
    effectDuration: 400,
    editorChangeThrottle: 800,
    visible: false,
    showVisibleTab: true,
    events: {
      "click .status-message": function(e) {
        var target;
        target = $(e.target).closest('.status-message');
        return target.remove();
      }
    },
    plugins: ["DocumentManager", "ModeSelector", "PreferencesPanel"],
    initialize: function(options) {
      this.options = options != null ? options : {};
      _.extend(this, this.options);
      _.bindAll(this, "editorChangeHandler");
      this.views = {};
      this.$el.addClass("" + this.position + "-positioned");
      if (this.autoRender !== false) {
        this.render();
      }
      return this.on("editor:change", _.debounce(this.editorChangeHandler, this.editorChangeThrottle), this);
    },
    setupCodeMirror: function() {
      var changeHandler,
        _this = this;
      if (this.codeMirror != null) {
        return;
      }
      this.height || (this.height = this.$el.height());
      this.codeMirror = CodeMirror(this.$('.codesync-asset-editor')[0], this.getCodeMirrorOptions());
      this.trigger("codemirror:setup");
      changeHandler = function(changeObj) {
        return _this.trigger("editor:change", _this.codeMirror.getValue(), changeObj);
      };
      this.codeMirror.on("change", _.debounce(changeHandler, this.editorChangeThrottle));
      return this;
    },
    codeMirrorKeyBindings: {
      "Ctrl-J": function() {
        return this.toggle();
      }
    },
    getCodeMirrorOptions: function() {
      var handler, keyCommand, options, _ref;
      _ref = this.codeMirrorKeyBindings;
      for (keyCommand in _ref) {
        handler = _ref[keyCommand];
        this.codeMirrorKeyBindings[keyCommand] = _.bind(handler, this);
      }
      return options = {
        theme: 'lesser-dark',
        lineNumbers: true,
        mode: CodeSync.Modes.guessModeFor(this.defaultExtension),
        extraKeys: this.codeMirrorKeyBindings
      };
    },
    editorChangeHandler: function(editorContents) {
      var documentModel;
      documentModel = this.views.documentManager.getCurrentDocument();
      return documentModel.set("contents", editorContents);
    },
    render: function() {
      var PluginClass, plugin, _i, _len, _ref,
        _this = this;
      if (this.rendered === true) {
        return this;
      }
      this.$el.html(JST["code_sync/editor/templates/asset_editor"]());
      _ref = this.plugins;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        plugin = _ref[_i];
        if (!(CodeSync.plugins[plugin] != null)) {
          continue;
        }
        PluginClass = CodeSync.plugins[plugin];
        PluginClass.setup.call(this, this);
      }
      this.delegateEvents();
      this.rendered = true;
      if (this.autoAppend === true) {
        $('body').prepend(this.el);
      }
      if (this.renderHidden === true) {
        this.show();
        setTimeout(function() {
          return _this.hide();
        }, 900);
      }
      return this;
    },
    onDocumentLoad: function(doc) {
      if (this.currentDocument != null) {
        this.currentDocument.off("status", this.showStatusMessage);
        this.currentDocument.off("change:compiled", this.loadDocumentInPage);
        this.currentDocument.off("change:mode", this.loadDocumentInPage, this);
      }
      this.currentDocument = doc;
      this.trigger("document:loaded", doc);
      this.codeMirror.swapDoc(this.currentDocument.toCodeMirrorDocument());
      this.currentDocument.on("status", this.showStatusMessage, this);
      this.currentDocument.on("change:compiled", this.loadDocumentInPage, this);
      return this.currentDocument.on("change:mode", this.loadDocumentInPage, this);
    },
    loadDocumentInPage: function() {
      var _ref,
        _this = this;
      return (_ref = this.currentDocument) != null ? _ref.loadInPage({
        complete: function() {
          var _ref1, _ref2, _ref3, _ref4;
          if (((_ref1 = _this.currentDocument) != null ? _ref1.type() : void 0) === "script") {
            if ((_ref2 = CodeSync.onScriptChange) != null) {
              _ref2.call(window, _this.currentDocument.attributes);
            }
          }
          if (((_ref3 = _this.currentDocument) != null ? _ref3.type() : void 0) === "stylesheet") {
            return (_ref4 = CodeSync.onStylesheetChange) != null ? _ref4.call(window, _this.currentDocument.attributes) : void 0;
          }
        }
      }) : void 0;
    },
    loadAdhocDocument: function() {
      var documentModel;
      documentModel = this.views.documentManager.createAdHocDocument();
      return this.views.documentManager.loadDocument(documentModel);
    },
    showStatusMessage: function(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      this.$('.status-message').remove();
      this.$el.prepend("<div class='status-message " + options.type + "'>" + options.message + "</div>");
      if (options.type === "success") {
        return _.delay(function() {
          return _this.$('.status-message').animate({
            opacity: 0
          }, {
            duration: 400,
            complete: function() {
              return _this.$('.status-message').remove();
            }
          });
        }, 1200);
      }
    },
    hiddenPosition: function() {
      var offset;
      if (this.position === "top") {
        offset = this.showVisibleTab ? this.$('.document-tabs-container').height() : 0;
        return {
          top: "" + ((this.height + 5) * -1 + offset) + "px"
        };
      }
    },
    effectSettings: function() {
      switch (this.effect) {
        case "slide":
          if (this.visible === true && this.position === "top") {
            return this.hiddenPosition();
          } else {
            return {
              top: "0px"
            };
          }
          break;
        case "fade":
          if (this.visible === true) {
            return {
              opacity: 0
            };
          } else {
            return {
              opacity: 0.98
            };
          }
      }
    },
    hide: function(withEffect) {
      var completeFn, view, viewName, _ref,
        _this = this;
      if (withEffect == null) {
        withEffect = true;
      }
      this.animating = true;
      _ref = this.views;
      for (viewName in _ref) {
        view = _ref[viewName];
        view.trigger("editor:hidden");
      }
      completeFn = _.debounce(function() {
        _this.visible = false;
        return _this.animating = false;
      }, this.effectDuration + 20);
      if (withEffect === true) {
        this.$el.animate(this.effectSettings(), {
          duration: this.effectDuration,
          complete: completeFn
        });
        _.delay(completeFn, this.effectDuration);
      } else {
        completeFn();
      }
      return this;
    },
    show: function(withEffect) {
      var completeFn, view, viewName, _ref,
        _this = this;
      if (withEffect == null) {
        withEffect = true;
      }
      this.setupCodeMirror();
      this.animating = true;
      _ref = this.views;
      for (viewName in _ref) {
        view = _ref[viewName];
        view.trigger("editor:visible");
      }
      completeFn = _.debounce(function() {
        _this.visible = true;
        return _this.animating = false;
      }, this.effectDuration);
      if (withEffect === true) {
        this.$el.animate(this.effectSettings(), {
          duration: this.effectDuration,
          complete: completeFn
        });
        _.delay(completeFn, this.effectDuration);
      } else {
        completeFn();
      }
      return this;
    },
    toggle: function() {
      if (this.animating === true) {
        return;
      }
      if (this.visible === true) {
        return this.hide(true);
      } else {
        return this.show(true);
      }
    },
    setKeyMap: function(keyMap) {
      return this.codeMirror.setOption('keyMap', keyMap);
    },
    setTheme: function(theme) {
      this.$el.attr("data-theme", theme);
      return this.codeMirror.setOption('theme', theme);
    },
    setMode: function(mode) {
      var codeMirrorMode;
      this.mode = mode;
      if (!_.isString(this.mode)) {
        codeMirrorMode = this.mode.get("codeMirrorMode");
      }
      this.codeMirror.setOption('mode', codeMirrorMode);
      this.currentDocument.set('mode', this.mode.get("codeMirrorMode"));
      this.currentDocument.set('extension', CodeSync.Modes.guessExtensionFor(this.mode.get("codeMirrorMode")));
      return this;
    }
  });

  CodeSync.AssetEditor.keyboardShortcutInfo = "ctrl+j: toggle editor ctrl+t: open asset";

  CodeSync.AssetEditor.toggleEditor = _.debounce(function(options) {
    if (options == null) {
      options = {};
    }
    if (window.codeSyncEditor != null) {
      return window.codeSyncEditor.toggle();
    } else {
      window.codeSyncEditor = new CodeSync.AssetEditor(options);
      $('body').prepend(window.codeSyncEditor.render().el);
      return window.codeSyncEditor.show();
    }
  }, 1);

  CodeSync.AssetEditor.setHotKey = function(hotKey, options) {
    if (options == null) {
      options = {};
    }
    return key(hotKey, function() {
      return CodeSync.AssetEditor.toggleEditor(options);
    });
  };

}).call(this);
(function() {



}).call(this);
(function() {



}).call(this);
