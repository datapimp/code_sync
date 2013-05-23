//     keymaster.js
//     (c) 2011-2012 Thomas Fuchs
//     keymaster.js may be freely distributed under the MIT license.
(function(a){function b(a,b){var c=a.length;while(c--)if(a[c]===b)return c;return-1}function c(a,c){var d,e,g,h,i;d=a.keyCode,b(u,d)==-1&&u.push(d);if(d==93||d==224)d=91;if(d in q){q[d]=!0;for(g in s)s[g]==d&&(f[g]=!0);return}if(!f.filter.call(this,a))return;if(!(d in p))return;for(h=0;h<p[d].length;h++){e=p[d][h];if(e.scope==c||e.scope=="all"){i=e.mods.length>0;for(g in q)if(!q[g]&&b(e.mods,+g)>-1||q[g]&&b(e.mods,+g)==-1)i=!1;(e.mods.length==0&&!q[16]&&!q[18]&&!q[17]&&!q[91]||i)&&e.method(a,e)===!1&&(a.preventDefault?a.preventDefault():a.returnValue=!1,a.stopPropagation&&a.stopPropagation(),a.cancelBubble&&(a.cancelBubble=!0))}}}function d(a){var c=a.keyCode,d,e=b(u,c);e>=0&&u.splice(e,1);if(c==93||c==224)c=91;if(c in q){q[c]=!1;for(d in s)s[d]==c&&(f[d]=!1)}}function e(){for(o in q)q[o]=!1;for(o in s)f[o]=!1}function f(a,b,c){var d,e,f,g;c===undefined&&(c=b,b="all"),a=a.replace(/\s/g,""),d=a.split(","),d[d.length-1]==""&&(d[d.length-2]+=",");for(f=0;f<d.length;f++){e=[],a=d[f].split("+");if(a.length>1){e=a.slice(0,a.length-1);for(g=0;g<e.length;g++)e[g]=s[e[g]];a=[a[a.length-1]]}a=a[0],a=t[a]||a.toUpperCase().charCodeAt(0),a in p||(p[a]=[]),p[a].push({shortcut:d[f],scope:b,method:c,key:d[f],mods:e})}}function g(a){if(typeof a=="string"){if(a.length!=1)return!1;a=a.toUpperCase().charCodeAt(0)}return b(u,a)!=-1}function h(){return u}function i(a){var b=(a.target||a.srcElement).tagName;return b!="INPUT"&&b!="SELECT"&&b!="TEXTAREA"}function j(a){r=a||"all"}function k(){return r||"all"}function l(a){var b,c,d;for(b in p){c=p[b];for(d=0;d<c.length;)c[d].scope===a?c.splice(d,1):d++}}function m(a,b,c){a.addEventListener?a.addEventListener(b,c,!1):a.attachEvent&&a.attachEvent("on"+b,function(){c(window.event)})}function n(){var b=a.key;return a.key=v,b}var o,p={},q={16:!1,18:!1,17:!1,91:!1},r="all",s={"⇧":16,shift:16,"⌥":18,alt:18,option:18,"⌃":17,ctrl:17,control:17,"⌘":91,command:91},t={backspace:8,tab:9,clear:12,enter:13,"return":13,esc:27,escape:27,space:32,left:37,up:38,right:39,down:40,del:46,"delete":46,home:36,end:35,pageup:33,pagedown:34,",":188,".":190,"/":191,"`":192,"-":189,"=":187,";":186,"'":222,"[":219,"]":221,"\\":220},u=[];for(o=1;o<20;o++)s["f"+o]=111+o;for(o in s)f[o]=!1;m(document,"keydown",function(a){c(a,r)}),m(document,"keyup",d),m(window,"focus",e);var v=a.key;a.key=f,a.key.setScope=j,a.key.getScope=k,a.key.deleteScope=l,a.key.filter=i,a.key.isPressed=g,a.key.getPressedKeyCodes=h,a.key.noConflict=n,typeof module!="undefined"&&(module.exports=key)})(this),function(){var a;window.KeyLauncher||(window.KeyLauncher={}),(a=window.KeyLauncher).loaders||(a.loaders={}),window.loadedScripts={},window.scriptTimers={},KeyLauncher.loaders.stylesheet=function(a,b,c){var d;return b==null&&(b={}),d=document.createElement("link"),d.type="text/css",d.rel="stylesheet",d.href=a,document.getElementsByTagName("head")[0].appendChild(d),c.call(this)},KeyLauncher.loaders.script=function(a,b,c){var d,e,f,g,h,i;b==null&&(b={}),e=loadedScripts,i=scriptTimers,typeof b=="function"&&c==null&&(c=b,b={}),d=document.getElementsByTagName("head")[0],g=document.createElement("script"),g.src=a,g.type="text/javascript",h=this,f=function(){typeof c=="function"&&c.call(h,a,b,g);try{d.removeChild(g)}catch(f){!0}return e[a]=!0};if(b.once===!0&&e[a])return!1;d.appendChild(g),g.onreadystatechange=function(){if(g.readyState==="loaded"||g.readyState==="complete")return f()},g.onload=f;if(typeof navigator!="undefined"&&navigator!==null?navigator.userAgent.match(/WebKit/):void 0)return i[a]=setInterval(function(){return f(),clearInterval(i[a])},10)}}.call(this),function(){window.KeyLauncher.Launcher=function(){function Launcher(a){var b,c,d;this.options=a!=null?a:{},this.fn=a.fn,this.before=a.before,this.command=a.command,d=this.options.requires;for(b in d)c=d[b],this._dependencies[c]={loaded:!1,provides:b}}return Launcher.prototype._dependencies={},Launcher.prototype.run=function(){var state,type,url,_ref,_ref1,_results,_this=this;this.ran=!1,(_ref=this.before)!=null&&typeof _ref.call=="function"&&_ref.call(this);if(this.isReady())return this.onReady();_ref1=this._dependencies,_results=[];for(url in _ref1){state=_ref1[url];try{state.loaded=eval(state.provides)!=null}catch(e){state.loaded=!1}state.loaded!==!0?(type=url.match(/\.css/)?"stylesheet":"script",_results.push(KeyLauncher.loaders[type](url,function(a){return _this.onDependencyLoad(a)}))):_results.push(void 0)}return _results},Launcher.prototype.requires=function(a){return this._dependencies[a]={loaded:!1}},Launcher.prototype.isReady=function(){var a,b,c,d;b=!0,d=this._dependencies;for(a in d)c=d[a],c.loaded===!1&&(b=!1);return b},Launcher.prototype.onDependencyLoad=function(a){this._dependencies[a].loaded=!0;if(this.isReady())return this.onReady()},Launcher.prototype.onReady=function(){var a=this;if(!this.isReady()||this.ran!==!1)return;return function(){return a.fn.call(a),a.ran=!0}()},Launcher}()}.call(this),function(){var a;KeyLauncher.VERSION="0.0.4",KeyLauncher.on=function(a,b,c){var d;c==null&&(c={});if(a==null)throw"Must specify a valid key command";return d=new KeyLauncher.Launcher({command:a,fn:b||function(){},before:c.before,requires:c.requires||[]}),key(a,function(){return d.run.call(d)}),d},a=function(a,b){var c,d,e,f,g;f=KeyLauncher.currentSequence||"",g=b.shortcut,KeyLauncher.currentSequence=""+f+g,e=function(){var a,b;a=KeyLauncher.sequences,b=[];for(c in a)d=a[c],c.match(KeyLauncher.currentSequence)&&b.push(c);return b}(),e.length>0||(KeyLauncher.currentSequence="");if(e.length===1&&(d=KeyLauncher.sequences[KeyLauncher.currentSequence]))return d.run.call(d),KeyLauncher.currentSequence=""},KeyLauncher.onSequence=function(b,c,d){var e,f,g,h,i;d==null&&(d={}),KeyLauncher.sequences||(KeyLauncher.sequences={}),f=KeyLauncher.sequences[b]=new KeyLauncher.Launcher({fn:c||function(){},requires:d.requires||[],before:d.before}),i=b.split("");for(g=0,h=i.length;g<h;g++)e=i[g],key(e,a);return f}}.call(this);
(function() {
  var CodeSync, root, _originalSetOption,
    __slice = [].slice;

  root = this;

  if (typeof exports !== "undefined") {
    CodeSync = exports;
  } else {
    CodeSync = root.CodeSync = {};
  }

  CodeSync.VERSION = "0.6.5";

  CodeSync.backends = {};

  CodeSync.util = {};

  CodeSync.plugins = {};

  CodeSync._config || (CodeSync._config = {
    defaultFileType: "coffeescript",
    assetCompilationEndpoint: "http://localhost:9295/source",
    serverInfoEndpoint: "http://localhost:9295/info",
    sprocketsEndpoint: "http://localhost:9295/assets",
    socketEndpoint: "http://localhost:9295/faye",
    editorToggleHotkey: "ctrl+j",
    debugMode: false
  });

  CodeSync.set = function(setting, value) {
    return CodeSync._config[setting] = value;
  };

  CodeSync.get = function(setting) {
    return CodeSync._config[setting];
  };

  CodeSync.enableLogging = function() {
    return CodeSync.set("debugMode", true);
  };

  CodeSync.log = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (CodeSync.get("debugMode") !== false) {
      args.unshift("CodeSync Log:");
      return console.log.apply(console, args);
    }
  };

  _originalSetOption = CodeMirror.prototype.setOption;

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

    Client.prototype.subscribeWith = function(cb) {
      var _ref;
      return (_ref = this.socket) != null ? _ref.subscribe("/code-sync/outbound", cb) : void 0;
    };

    Client.prototype.setupSocket = function() {
      var _this = this;
      if (typeof Faye === "undefined" || Faye === null) {
        return;
      }
      this.socket = new Faye.Client(CodeSync.get("socketEndpoint"));
      return this.subscribeWith(function(notification) {
        var _ref, _ref1, _ref2;
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
        _buf.push("<div class=\"toolbar-wrapper\"></div><div class=\"codesync-asset-editor\"></div>");
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
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/document_manager_tab"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var classes, displayValue, _buf, _ref, _ref1, _ref2, _temple_coffeescript_attributeremover1, _temple_coffeescript_attributeremover2;
        _buf = [];
        displayValue = this.display || this.doc.get("display") || this.doc.get("name");
        classes = ["document-tab"];
        if (this.cls != null) {
          classes.push(this.cls);
        }
        if (this.doc != null) {
          classes.push("selectable");
        }
        if (this.closable && !((_ref = this.doc) != null ? _ref.isSticky() : void 0)) {
          classes.push("closable");
        }
        if (this.index !== 0) {
          classes.push("hideable");
        }
        if ((this.doc != null) && !((_ref1 = this.doc) != null ? _ref1.isSticky() : void 0)) {
          classes.push("editable");
        }
        _buf.push("<div");
        _temple_coffeescript_attributeremover1 = [];
        _temple_coffeescript_attributeremover1.push(this.escape(classes.join(' ')));
        _temple_coffeescript_attributeremover1.join('');
        if (_temple_coffeescript_attributeremover1.length > 0) {
          _buf.push(" class=\"");
          _buf.push(_temple_coffeescript_attributeremover1);
          _buf.push("\"");
        }
        _temple_coffeescript_attributeremover2 = [];
        _temple_coffeescript_attributeremover2.push(this.escape((_ref2 = this.doc) != null ? _ref2.cid : void 0));
        _temple_coffeescript_attributeremover2.join('');
        if (_temple_coffeescript_attributeremover2.length > 0) {
          _buf.push(" data-document-cid=\"");
          _buf.push(_temple_coffeescript_attributeremover2);
          _buf.push("\"");
        }
        _buf.push("><span class=\"contents\">");
        _buf.push(this.escape(displayValue));
        _buf.push("</span><small class=\"close-anchor\">x</small></div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/element_sync"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"element-sync-panel\"><div class=\"row\"><div class=\"span9\"><input name=\"css-selector\" placeholder=\"Enter a CSS selector to sync with\" /></div><div class=\"span3\"><select name=\"action\"><option value=\"html\">Replace</option><option value=\"before\">Before</option><option value=\"before\">After</option></select></div></div><div class=\"row\"><div class=\"span9\"><div class=\"element-sync-status\"></div><input class=\"done-button\" type=\"button\" value=\"Done\" /><input class=\"hide-panel-button\" type=\"button\" value=\"Hide\" /></div></div></div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["code_sync/editor/templates/preferences_panel"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf, _temple_coffeescript_attributeremover1, _temple_coffeescript_attributeremover2;
        _buf = [];
        _buf.push("<form><div class=\"control-group\"><label>KeyBindings</label><div class=\"controls\"><select name=\"keyMap\"><option value=\"default\">Default</option><option value=\"vim\">Vim</option></select></div></div><div class=\"control-group\"><label>Theme</label><div class=\"controls\"><select name=\"theme\"><option value=\"ambiance\">Ambiance</option><option value=\"lesser-dark\">Lesser Dark</option><option value=\"monokai\">Monokai</option><option value=\"xq-light\">XQ Light</option></select></div></div><div class=\"control-group\"><label>Asset Compiler Endpoint</label><div class=\"controls\"><input name=\"asset_endpoint\" type=\"text\"");
        _temple_coffeescript_attributeremover1 = [];
        _temple_coffeescript_attributeremover1.push(this.escape(CodeSync.get('assetCompilationEndpoint')));
        _temple_coffeescript_attributeremover1.join('');
        if (_temple_coffeescript_attributeremover1.length > 0) {
          _buf.push(" value=\"");
          _buf.push(_temple_coffeescript_attributeremover1);
          _buf.push("\"");
        }
        _buf.push(" /></div></div><div class=\"control-group\"><label>Hotkey</label><div class=\"controls\"><input name=\"editor_hotkey\" type=\"text\"");
        _temple_coffeescript_attributeremover2 = [];
        _temple_coffeescript_attributeremover2.push(this.escape(CodeSync.get('editorToggleHotkey')));
        _temple_coffeescript_attributeremover2.join('');
        if (_temple_coffeescript_attributeremover2.length > 0) {
          _buf.push(" value=\"");
          _buf.push(_temple_coffeescript_attributeremover2);
          _buf.push("\"");
        }
        _buf.push(" /></div></div><div class=\"control-group\"><label>Position</label><div class=\"controls\"><select name=\"position\"><option value=\"top\">Top</option><option value=\"bottom\">Bottom</option></select></div></div></form>");
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
      var localKey, _base,
        _this = this;
      this.attributes = attributes;
      if (localKey = this.attributes.localStorageKey) {
        (_base = this.attributes).contents || (_base.contents = localStorage.getItem(localKey));
      }
      Backbone.Model.prototype.initialize.apply(this, arguments);
      _.bindAll(this, "onContentChange");
      this.on("change:contents", this.onContentChange);
      this.on("change:name", function() {
        _this.set("mode", _this.determineMode());
        return _this.set("display", _this.nameWithoutExtension());
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
      if (this.isSaveable()) {
        return this.sendToServer(true, "saveToDisk");
      }
    },
    saveToLocalStorage: function(path) {
      if (path != null) {
        return localStorage.setItem(path, this.get("contents"));
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
    toJSON: function() {
      return {
        name: this.nameWithoutExtension(),
        path: this.get('path'),
        extension: this.get('extension') || this.determineExtension(),
        contents: this.toContent()
      };
    },
    nameWithoutExtension: function() {
      var extension;
      extension = this.get('extension') || this.determineExtension();
      return (this.get("name") || "untitled").replace(extension, '');
    },
    toMode: function() {
      var mode, modeModel;
      mode = this.get("mode") || this.determineMode();
      return modeModel = CodeSync.Modes.getMode(mode);
    },
    toCodeMirrorMode: function() {
      var _ref;
      return (_ref = this.toMode()) != null ? _ref.get("codeMirrorMode") : void 0;
    },
    toCodeMirrorDocument: function() {
      return CodeMirror.Doc(this.toContent(), this.toCodeMirrorMode(), 0);
    },
    toCodeMirrorOptions: function() {
      return this.toMode().get("codeMirrorOptions");
    },
    toContent: function() {
      var _ref;
      return "" + (this.get("contents") || ((_ref = this.toMode()) != null ? _ref.get("defaultContent") : void 0) || " ");
    },
    onContentChange: function() {
      var localKey;
      localKey = this.get("localStorageKey");
      localKey = (localKey != null) && _.isFunction(localKey) ? localKey.call(this) : localKey;
      localStorage.setItem(localKey, this.get("contents"));
      return this.sendToServer(false, "onContentChange");
    },
    sendToServer: function(allowSaveToDisk, reason) {
      var data,
        _this = this;
      if (allowSaveToDisk == null) {
        allowSaveToDisk = false;
      }
      if (reason == null) {
        reason = "";
      }
      if (!this.isSaveable()) {
        allowSaveToDisk = false;
      }
      data = allowSaveToDisk === true ? this.toJSON() : _(this.toJSON()).pick('name', 'extension', 'contents');
      CodeSync.log("Sending Data To " + (CodeSync.get("assetCompilationEndpoint")), data);
      return $.ajax({
        type: "POST",
        url: CodeSync.get("assetCompilationEndpoint"),
        data: JSON.stringify(data),
        error: function(response) {
          return CodeSync.log("Document Process Error", arguments);
        },
        success: function(response) {
          var _ref, _ref1;
          CodeSync.log("Document Process Response", response);
          if (response.success === true) {
            _this.trigger("status", {
              type: "success",
              message: _this.successMessage(reason),
              compiled: response.compiled
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
      } else if (this.type() === "script" || this.type() === "template") {
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
          return "script";
        case "skim":
        case "mustache":
        case "jst":
        case "haml":
        case "eco":
          return "template";
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
    },
    successMessage: function(reason) {
      if (this.type() === "template") {
        return "Success.  Template will be available as JST[\"" + (this.nameWithoutExtension()) + "\"]";
      }
    },
    isSticky: function() {
      return (this.get("sticky") != null) === true;
    },
    isSaveable: function() {
      var _ref;
      return ((_ref = this.get("path")) != null ? _ref.length : void 0) > 0 && !this.get("doNotSave");
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
    initialize: function(models, options) {
      var client;
      Backbone.Collection.prototype.initialize.apply(this, arguments);
      if (client = CodeSync.Client.get() && ((client != null ? client.socket : void 0) != null)) {
        return client.subscribeWith(function(notification) {
          return console.log("Documents", notification);
        });
      }
    },
    nextId: function() {
      return this.models.length + 1;
    },
    findByPath: function(path) {
      var documentModel;
      return documentModel = this.detect(function(documentModel) {
        var _ref;
        return (_ref = documentModel.get('path')) != null ? _ref.match(path) : void 0;
      });
    },
    findOrCreateForPath: function(path, callback) {
      var display, documentModel, extension, id, name,
        _this = this;
      if (path == null) {
        path = "";
      }
      if (documentModel = this.findByPath(path)) {
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
        return documentModel.loadSourceFromDisk(function() {
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
      var doc, evalRunner;
      doc = this;
      evalRunner = function(code) {
        try {
          return eval(code);
        } catch (e) {
          doc.trigger("status", {
            type: "error",
            message: "JS Error: " + e.message,
            sticky: true
          });
          throw e;
        }
      };
      return evalRunner.call(window, code);
    }
  };

}).call(this);
(function() {

  CodeSync.Gist = Backbone.Model.extend({
    initialize: function(attributes) {
      this.attributes = attributes != null ? attributes : {};
    },
    url: function() {},
    toDocuments: function() {}
  });

}).call(this);
(function() {
  var modes;

  CodeSync.Modes = Backbone.Collection.extend({
    model: Backbone.Model.extend({
      isTemplate: function() {
        return this.get("template") === true;
      }
    }),
    initialize: function(models, options) {
      var attributes, key, value;
      if (models == null) {
        models = [];
      }
      if (options == null) {
        options = {};
      }
      models = (function() {
        var _ref, _results;
        _results = [];
        for (key in modes) {
          value = modes[key];
          _results.push(attributes = {
            id: key,
            name: value.name || key,
            codeMirrorMode: value.codeMirrorMode || key,
            extension: value.extension,
            extensionRegex: new RegExp("" + value.extension),
            template: value.template === true || key === "skim" || ((_ref = value.extension) != null ? _ref.match(/jst/) : void 0),
            defaultContent: value.defaultContent
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
      return this.get(CodeSync.get("defaultFileType")) || this.first();
    }
  });

  CodeSync.Modes.getMode = function(id) {
    return CodeSync.Modes.get().get(id);
  };

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

  CodeSync.Modes.defaultMode = function() {
    return CodeSync.Modes.get().defaultMode();
  };

  modes = {
    coffeescript: {
      extension: ".coffee",
      codeMirrorOptions: {
        indentUnit: 2,
        smartIndent: true,
        tabSize: 2,
        indentWithTabs: false
      },
      defaultContent: "# You are currently in Coffeescript Mode\n#\n# Any coffeescript you type in here will be evaluated.\n#\n# defining this function will allow you to respond\n# to code and template changes that happen in this editor.\n#\n#\n# CodeSync.onScriptChange = (changeObject)->\n#   console.log \"Detected new code from CodeSync\", changeObject\n#\n#"
    },
    sass: {
      name: "Sass",
      extension: ".css.sass",
      defaultContent: "// You are currently in Sass mode.",
      codeMirrorOptions: {
        indentUnit: 2,
        smartIndent: true,
        tabSize: 2,
        indentWithTabs: false
      }
    },
    scss: {
      codeMirrorMode: "css",
      extension: ".css.scss",
      name: "SCSS",
      defaultContent: "/* You are currently in SCSS mode. */"
    },
    skim: {
      extension: ".jst.skim",
      defaultContent: "// You are currently in Skim mode.\n// The contents of this template will be available on the JST object.",
      template: true,
      codeMirrorOptions: {
        indentUnit: 2,
        smartIndent: true,
        tabSize: 2,
        indentWithTabs: false
      }
    },
    css: {
      name: "CSS",
      extension: ".css",
      defaultContent: "/* You are currently in raw CSS mode. */"
    },
    javascript: {
      name: "Javascript",
      extension: ".js",
      defaultContent: "/* You are currently in raw JS mode. */"
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

  CodeSync.plugins.ColorPicker = Backbone.View.extend({
    className: "codesync-color-picker",
    widget: false,
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
      if (!this.widget) {
        this.$el.addClass('anchored');
      }
      return this.$el.show();
    },
    syncWithToken: function(token, cursor) {
      var cm, endch, line, startch,
        _this = this;
      cm = this.editor.codeMirror;
      if (this.widget === true) {
        this.$el.removeClass('anchored');
        cm.addWidget(cursor, this.el);
      }
      this.show();
      line = cm.getLine(cursor.line);
      startch = token.start;
      endch = token.end;
      this.widget.spectrum("set", token.string);
      return this.on("color:change", _.debounce(function(colorObject, hexValue) {
        return cm.replaceRange("#" + hexValue, {
          line: cursor.line,
          ch: startch
        }, {
          line: cursor.line,
          ch: endch
        });
      }, 1200));
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
(function() {

  CodeSync.DocumentManager = Backbone.Model.extend({
    initialize: function(attributes) {
      var trigger, _i, _len, _ref;
      this.attributes = attributes != null ? attributes : {};
      this.editor = this.attributes.editor;
      delete this.attributes.editor;
      this.openDocuments = new CodeSync.Documents();
      _ref = ["add", "remove", "change:display", "change:sticky"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        trigger = _ref[_i];
        this.openDocuments.on(trigger, this.notify, this);
      }
      return Backbone.Model.prototype.initialize.apply(this, arguments);
    },
    getEditor: function() {
      return this.editor || _(CodeSync.AssetEditor.instances).values()[0];
    },
    detect: function(iterator) {
      return this.openDocuments.each(iterator);
    },
    each: function(iterator) {
      return this.openDocuments.each(iterator);
    },
    notify: function() {
      return this.trigger("document:change");
    },
    openDocument: function(doc, editor) {
      editor || (editor = this.getEditor());
      this.openDocuments.add(doc);
      return this.setCurrentDocument(doc, editor);
    },
    setCurrentDocument: function(currentDocument, editor) {
      this.currentDocument = currentDocument;
      editor || (editor = this.editor);
      return editor.loadDocument(this.currentDocument);
    },
    saveDocument: function() {
      if (CodeSync.get("disableAssetSave")) {
        return this.getEditor().showError("Saving is disabled.");
      } else {
        return this.currentDocument.saveToDisk();
      }
    },
    createDocument: function(editor) {
      var doc, extension, mode, _ref;
      editor || (editor = this.getEditor());
      mode = ((_ref = editor.mode) != null ? _ref.id : void 0) || CodeSync.get("defaultFileType");
      extension = CodeSync.Modes.guessExtensionFor(mode);
      doc = new CodeSync.Document({
        name: "untitled",
        display: "Untitled",
        mode: mode,
        extension: extension
      });
      return this.openDocument(doc, editor);
    }
  });

}).call(this);
(function() {

  CodeSync.plugins.DocumentTabs = Backbone.View.extend({
    includeActionTabs: true,
    allowNew: true,
    allowOpen: true,
    allowSave: CodeSync.get("allowSaving") === true,
    events: {
      "click .selectable": "onDocumentTabSelection",
      "click .closable .close-anchor": "closeTab",
      "click .new-document": "createDocument",
      "click .save-document": "saveDocument",
      "click .open-document": "toggleAssetSelector",
      "dblclick .editable": "onDoubleClickTab",
      "blur .editable .contents": "onEditableTabBlur",
      "keydown .editable .contents": "onEditableTabKeyPress"
    },
    tabTemplate: JST["code_sync/editor/templates/document_manager_tab"],
    views: {},
    initialize: function(options) {
      var _this = this;
      this.options = options != null ? options : {};
      _.extend(this, options);
      this.editor = options.editor;
      this.manager = this.editor.documentManager;
      this.docs = this.manager.openDocuments;
      this.manager.on("document:change", this.renderTabs, this);
      this.projectAssets = new CodeSync.ProjectAssets();
      this.on("editor:hidden", function() {
        return _this.$('.document-tab.hideable').hide();
      });
      this.on("editor:visible", function() {
        return _this.$('.document-tab.hideable').show();
      });
      this.views.assetSelector = new CodeSync.AssetSelector({
        collection: this.projectAssets,
        documents: this.docs,
        editor: this.editor
      });
      this.views.assetSelector.on("asset:selected", this.onAssetSelection, this);
      return Backbone.View.prototype.initialize.apply(this, arguments);
    },
    tabsContainer: function() {
      var el;
      return el = this.$('.document-tabs-container');
    },
    documentInTab: function(tabElement) {
      var cid, doc;
      if (!tabElement.is('.document-tab')) {
        tabElement = tabElement.parents('.document-tab').eq(0);
      }
      if (cid = tabElement.data('document-cid')) {
        return doc = this.docs.detect(function(model) {
          return model.cid === cid;
        });
      }
    },
    renderTabs: function() {
      var container, tmpl,
        _this = this;
      container = this.tabsContainer().empty();
      tmpl = this.tabTemplate;
      this.docs.each(function(doc, index) {
        if (!(_this.skipTabForDefault === true && index === 0)) {
          return container.append(tmpl({
            doc: doc,
            index: index,
            closable: !!(index > 0)
          }));
        }
      });
      if (this.includeActionTabs) {
        if (this.allowOpen) {
          this.addOpenDocumentTab();
        }
        if (this.allowNew) {
          return this.addNewDocumentTab();
        }
      }
    },
    addOpenDocumentTab: function() {
      return this.tabsContainer().append(this.tabTemplate({
        display: "Open",
        cls: "open-document"
      }));
    },
    addNewDocumentTab: function() {
      return this.tabsContainer().append(this.tabTemplate({
        display: "New",
        cls: "new-document"
      }));
    },
    addSaveDocumentTab: function() {
      return this.tabsContainer().append(this.tabTemplate({
        display: "Save",
        cls: "save-document"
      }));
    },
    onAssetSelection: function(path) {
      var _this = this;
      return this.docs.findOrCreateForPath(path, function(doc) {
        return _this.manager.openDocument(doc, _this.editor);
      });
    },
    onEditableTabKeyPress: function(e) {
      var contents, doc, original, target;
      target = this.$(e.target).closest('.document-tab');
      contents = target.children('.contents');
      console.log("On Editable Tab Keypress", e.keyCode, e.which);
      if (e.keyCode === 13 || e.keyCode === 27) {
        e.preventDefault();
        contents.attr('contenteditable', false);
        if (doc = this.documentInTab(target)) {
          if (e.keyCode === 13) {
            doc.set('name', contents.html());
          }
          if (e.keyCode === 27 && (original = target.attr('data-original-value'))) {
            contents.html(original);
          }
        }
        return this.restoreFocus();
      }
    },
    restoreFocus: function() {
      return this.editor.codeMirror.focus();
    },
    onEditableTabBlur: function(e) {
      var contents, doc, target;
      console.log("On Editable Tab Blur");
      target = this.$(e.target).closest('.document-tab');
      contents = target.children('.contents');
      if (doc = this.documentInTab(target)) {
        doc.set('name', contents.html());
        return contents.attr('contenteditable', false);
      }
    },
    onDoubleClickTab: function(e) {
      var contents, target;
      console.log("On Double Click Tab");
      target = this.$(e.target).closest('.document-tab');
      contents = target.children('.contents');
      target.attr('data-original-value', contents.html());
      return contents.attr('contenteditable', true);
    },
    onDocumentTabSelection: function(e) {
      var doc, target;
      this.trigger("tab:click");
      target = this.$(e.target).closest('.document-tab');
      doc = this.documentInTab(target);
      return this.manager.setCurrentDocument(doc, this.editor);
    },
    closeTab: function(e) {
      var doc, index, target;
      target = this.$(e.target);
      doc = this.documentInTab(target);
      index = this.docs.indexOf(doc);
      this.docs.remove(doc);
      return this.manager.setCurrentDocument(this.docs.at(index - 1) || this.docs.at(0), this.editor);
    },
    createDocument: function() {
      return this.manager.createDocument();
    },
    toggleAssetSelector: function() {
      return this.views.assetSelector.toggle();
    },
    render: function() {
      this.$el.append("<div class='document-tabs-container' />");
      this.$el.append(this.views.assetSelector.render().el);
      return this;
    }
  });

  CodeSync.plugins.DocumentTabs.setup = function(editor, options) {
    var dm,
      _this = this;
    if (options == null) {
      options = {};
    }
    options.editor = editor;
    dm = this.views.documentTabs = new CodeSync.plugins.DocumentTabs(options);
    this.$el.append(dm.render().el);
    return dm.on("tab:click", function() {
      if (_this.visible === false) {
        return _this.show();
      }
    });
  };

}).call(this);
(function() {

  CodeSync.plugins.ElementSync = Backbone.View.extend({
    className: "codesync-element-sync toggleable-input",
    action: "html",
    events: {
      "keyup input": function() {
        return this.bindToSelector();
      },
      "change select": function(e) {
        return this.action = this.$(e.target).val();
      },
      "click .hide-panel-button": function() {
        return this.hide();
      },
      "click .done-button": function() {
        return this.clear();
      }
    },
    initialize: function(options) {
      var _this = this;
      this.options = options != null ? options : {};
      _.extend(this, this.options);
      this.bindToSelector = _.debounce(function() {
        _this.selector = _this.getValue();
        _this.$elementSync = $(_this.selector);
        return _this.status();
      }, 500);
      this.editor.on("code:sync:template", this.syncWithElement, this);
      this.editor.on("change:mode", function(mode) {
        if (mode.isTemplate()) {
          return _this.toggleButton(true);
        } else {
          _this.hide();
          return _this.toggleButton(false);
        }
      });
      this.visible = false;
      this.$el.hide();
      return this.toggleButton(false);
    },
    syncWithElement: function(doc, templateFn) {
      var _name, _ref;
      return this.selector && ((_ref = this.$elementSync) != null ? typeof _ref[_name = this.action || "html"] === "function" ? _ref[_name](templateFn()) : void 0 : void 0);
    },
    getSelectorContents: function() {
      return this.$(this.selector).html();
    },
    getValue: function() {
      return this.$('input[name="css-selector"]').val();
    },
    clear: function() {
      this.$('input[name="css-selector"]').val('');
      this.$elementSync = void 0;
      this.selector = '';
      return this.$('.element-sync-status').html("");
    },
    existsInDocument: function() {
      var _ref;
      return ((_ref = this.$elementSync) != null ? _ref.length : void 0) > 0;
    },
    status: function() {
      var length, msg, _ref;
      length = (_ref = this.$elementSync) != null ? _ref.length : void 0;
      msg = length === 0 && this.getValue().length > 0 ? "CSS Selector not found" : length === 1 ? "1 total element" : length > 0 ? "" + length + " total elements" : "";
      return this.$('.element-sync-status').html(msg);
    },
    render: function() {
      this.$el.html(JST["code_sync/editor/templates/element_sync"]());
      this.status();
      return this;
    },
    show: function() {
      this.visible = true;
      return this.$el.show();
    },
    hide: function() {
      this.visible = false;
      return this.$el.hide();
    },
    toggle: function() {
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    },
    toggleButton: function(show) {
      if (show == null) {
        show = true;
      }
      if (show) {
        return this.editor.$('.toggle-element-sync').show();
      } else {
        return this.editor.$('.toggle-element-sync').hide();
      }
    }
  });

  CodeSync.plugins.ElementSync.setup = function(editor) {
    var view,
      _this = this;
    this.$('.toolbar-wrapper').append("<div class='button toggle-element-sync'>Sync w/ Element</div>");
    view = new CodeSync.plugins.ElementSync({
      editor: editor
    });
    editor.views.elementSync = view;
    this.events["click .toggle-element-sync"] = function() {
      return view.toggle();
    };
    return this.$el.append(view.render().el);
  };

}).call(this);
(function() {

  CodeSync.plugins.KeymapSelector = Backbone.View.extend({
    className: "config-select keymap-selector",
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
    hideLabel: function() {
      return this.$('label').hide();
    },
    showLabel: function() {
      return this.$('label').show();
    },
    render: function() {
      var mode, options, _i, _len, _ref;
      options = "";
      _ref = ["default", "vim"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mode = _ref[_i];
        options += "<option value='" + mode + "'>" + mode + "</option>";
      }
      this.$el.html("<label>Keymap</label> <select>" + options + "</select>");
      if (!this.visibleLabel) {
        this.hideLabel();
      }
      return this;
    }
  });

  CodeSync.plugins.KeymapSelector.setup = function(editor) {
    var v;
    v = this.views.keymapSelector = new CodeSync.plugins.KeymapSelector({
      editor: editor
    });
    return this.$('.toolbar-wrapper').append(v.render().el);
  };

}).call(this);
(function() {

  CodeSync.plugins.ModeSelector = Backbone.View.extend({
    className: "config-select mode-selector",
    events: {
      "change select": "onSelect"
    },
    initialize: function(options) {
      var _this = this;
      if (options == null) {
        options = {};
      }
      this.editor = options.editor;
      this.modes = this.editor.modes;
      this.modes.on("reset", this.render, this);
      this.editor.on("change:mode", function(modeModel, modeId) {
        return _this.setValue(modeId);
      });
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
    hideLabel: function() {
      return this.$('label').hide();
    },
    showLabel: function() {
      return this.$('label').show();
    },
    render: function() {
      var mode, options, _i, _len, _ref;
      options = "";
      _ref = this.modes.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mode = _ref[_i];
        options += "<option value='" + mode.id + "'>" + (mode.get('name')) + "</option>";
      }
      this.$el.html("<label>Language:</label> <select>" + options + "</select>");
      if (!this.visibleLabel) {
        this.hideLabel();
      }
      return this;
    }
  });

  CodeSync.plugins.ModeSelector.setup = function(editor) {
    var v;
    v = this.views.modeSelector = new CodeSync.plugins.ModeSelector({
      editor: editor
    });
    this.$('.toolbar-wrapper').append(v.render().el);
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

  CodeSync.plugins.PreferencesPanel = Backbone.View.extend({
    className: "preferences-panel",
    events: {
      "change select,input": function() {
        return this.trigger("update:preferences");
      }
    },
    renderHidden: true,
    initialize: function(options) {
      this.editor = options.editor;
      this.$el.html(JST["code_sync/editor/templates/preferences_panel"]());
      return Backbone.View.prototype.initialize.apply(this, arguments);
    },
    values: function() {
      var el, input, values, _i, _len, _ref;
      values = {};
      _ref = this.$('input,select');
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
    syncWithEditorOptions: function() {
      this.$('select[name="theme"]').val(this.editor.codeMirror.getOption('theme'));
      this.$('select[name="keyMap"]').val(this.editor.codeMirror.getOption('keyMap'));
      this.$('input[name="asset_endpoint"]').val(CodeSync.get("assetCompilationEndpoint"));
      return this.$('input[name="editor_hotkey"]').val(CodeSync.get("editorToggleHotKey"));
    },
    render: function() {
      if (this.renderHidden === true) {
        this.$el.hide();
      }
      return this;
    }
  });

  CodeSync.plugins.PreferencesPanel.setup = function(editor) {
    var panel,
      _this = this;
    panel = new CodeSync.plugins.PreferencesPanel({
      editor: this
    });
    this.$('.toolbar-wrapper').append("<div class='button toggle-preferences'>Preferences</div>");
    this.events["click .toggle-preferences"] = function() {
      return panel.toggle();
    };
    this.$el.append(panel.render().el);
    panel.on("update:preferences", function() {
      var values;
      values = panel.values();
      editor.setTheme(values.theme);
      editor.setKeyMap(values.keyMap);
      CodeSync.set("assetCompilationEndpoint", values.asset_endpoint);
      return CodeSync.AssetEditor.setHotKey(values.editor_hotkey);
    });
    editor.on("codemirror:setup", function(cm) {
      return cm.on("focus", function() {
        return panel.$el.hide();
      });
    });
    return panel.on("update:preferences", function() {
      var values;
      values = panel.values();
      if (editor.position !== values.position) {
        return editor.setPosition(values.position);
      }
    });
  };

}).call(this);
(function() {

  CodeSync.AssetEditor = Backbone.View.extend({
    name: "code_sync",
    className: "codesync-editor",
    position: "top",
    enableToolbar: true,
    enableStatusMessages: true,
    autoRender: true,
    autoAppend: true,
    appendTo: "body",
    renderVisible: true,
    effect: "slide",
    effectDuration: 400,
    editorChangeThrottle: 800,
    visible: false,
    showVisibleTab: true,
    hideable: true,
    startMode: "scss",
    theme: "ambiance",
    keyBindings: "",
    events: {
      "click .status-message": "removeStatusMessages",
      "click .hide-button": "hide"
    },
    plugins: ["DocumentTabs", "ModeSelector", "PreferencesPanel", "ElementSync", "KeymapSelector"],
    pluginOptions: {},
    views: {},
    initialize: function(options) {
      var _this = this;
      this.options = options != null ? options : {};
      _.extend(this, this.options);
      Backbone.View.prototype.initialize.apply(this, arguments);
      console.log("Creatin Instance", this.name, this.cid, this);
      CodeSync.AssetEditor.instances[this.name || this.cid] = this;
      _.bindAll(this, "editorChangeHandler");
      this.modes = CodeSync.Modes.get();
      this.documentManager = new CodeSync.DocumentManager({
        editor: this
      });
      this.startMode = this.modes.get(this.startMode) || CodeSync.Modes.defaultMode();
      this.on("editor:change", _.debounce(this.editorChangeHandler, this.editorChangeThrottle), this);
      this.on("codemirror:setup", function() {
        return _this.loadDefaultDocument();
      });
      this.$el.html(JST["code_sync/editor/templates/asset_editor"]());
      if (this.name != null) {
        this.$el.attr('data-codesync', this.name);
      }
      this.loadPlugins();
      this.setPosition(this.position, false);
      if (this.autoRender !== false) {
        return this.render();
      }
    },
    addPlugin: function(plugin) {
      var _ref;
      return (_ref = CodeSync.plugins[plugin]) != null ? _ref.setup.call(this, this) : void 0;
    },
    loadPlugins: function() {
      var PluginClass, options, plugin, _i, _len, _ref, _results;
      _ref = this.plugins;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        plugin = _ref[_i];
        if (!(CodeSync.plugins[plugin] != null)) {
          continue;
        }
        options = this.pluginOptions[plugin] || {};
        PluginClass = CodeSync.plugins[plugin];
        _results.push(PluginClass.setup.call(this, this, options));
      }
      return _results;
    },
    render: function() {
      var _this = this;
      if (this.rendered === true) {
        return this;
      }
      this.setupToolbar();
      this.delegateEvents();
      this.rendered = true;
      if (this.autoAppend === true) {
        $(this.appendTo).prepend(this.el);
      }
      if (this.renderHidden === true) {
        this.show();
        setTimeout(function() {
          return _this.hide();
        }, 900);
      }
      if (this.renderVisible === true) {
        this.show();
      }
      return this;
    },
    setupCodeMirror: function() {
      var changeHandler,
        _this = this;
      if (this.codeMirror != null) {
        return;
      }
      this.height || (this.height = this.$el.height());
      this.codeMirror = CodeMirror(this.$('.codesync-asset-editor')[0], this.getCodeMirrorOptions());
      this.on("initial:document:load", function() {
        if (_this.startMode) {
          _this.setMode(_this.startMode);
        }
        if (_this.keyBindings) {
          _this.setKeyMap(_this.keyBindings);
        }
        if (_this.theme || (_this.theme = localStorage.getItem("codesync:theme"))) {
          return _this.setTheme(_this.theme);
        }
      });
      changeHandler = function(changeObj) {
        return _this.trigger("editor:change", _this.codeMirror.getValue(), changeObj);
      };
      this.codeMirror.on("change", _.debounce(changeHandler, this.editorChangeThrottle));
      this.trigger("codemirror:setup", this.codeMirror);
      return this;
    },
    codeMirrorKeyBindings: {
      "Ctrl+Command+1": function() {
        var _ref;
        return (_ref = CodeSync.get("commandOne")) != null ? typeof _ref.call === "function" ? _ref.call(this) : void 0 : void 0;
      },
      "Ctrl+Command+2": function() {
        var _ref;
        return (_ref = CodeSync.get("commandTwo")) != null ? typeof _ref.call === "function" ? _ref.call(this) : void 0 : void 0;
      },
      "Ctrl+Command+3": function() {
        var _ref;
        return (_ref = CodeSync.get("commandThree")) != null ? _ref.call(this) : void 0;
      }
    },
    getCodeMirrorOptions: function() {
      var handler, keyCommand, options, passthrough, _ref, _ref1;
      passthrough = {};
      _ref = this.codeMirrorKeyBindings;
      for (keyCommand in _ref) {
        handler = _ref[keyCommand];
        passthrough[keyCommand] = false;
        key(keyCommand, _.bind(handler, this));
      }
      return options = {
        theme: 'lesser-dark',
        lineNumbers: true,
        mode: ((_ref1 = this.startMode) != null ? _ref1.get("codeMirrorMode") : void 0) || CodeSync.get("defaultFileType"),
        extraKeys: passthrough
      };
    },
    editorChangeHandler: function(editorContents) {
      return this.currentDocument.set("contents", editorContents);
    },
    setPosition: function(position, show) {
      var available, _i, _len, _ref;
      this.position = position != null ? position : "top";
      if (show == null) {
        show = true;
      }
      _ref = ["top", "bottom", "static"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        available = _ref[_i];
        if (available !== this.position) {
          this.$el.removeClass("" + available + "-positioned");
        }
      }
      this.$el.addClass("" + this.position + "-positioned");
      this.$el.removeAttr('style');
      if (show === true) {
        this.show();
      }
      return this;
    },
    setKeyMap: function(keyMap) {
      var _ref;
      if ((this.keyMap != null) && keyMap !== this.keyMap) {
        this.trigger("change:keyMap", keyMap, this.keyMap);
        if ((_ref = this.onKeyMapChange) != null) {
          _ref.call(this, keyMap, this.keyMap);
        }
      }
      return this.codeMirror.setOption('keyMap', this.keyMap = keyMap);
    },
    setTheme: function(theme) {
      var _ref;
      if ((this.theme != null) && theme !== this.theme) {
        this.trigger("change:theme", theme, this.theme);
        if ((_ref = this.onThemeChange) != null) {
          _ref.call(this, theme, this.theme);
        }
      }
      this.$el.attr("data-codesync-theme", this.theme = theme);
      return this.codeMirror.setOption('theme', this.theme = theme);
    },
    setMode: function(newMode) {
      var _ref, _ref1;
      if ((this.mode != null) && (newMode !== this.mode)) {
        this.trigger("change:mode", newMode, newMode.id);
        if ((_ref = this.onModeChange) != null) {
          _ref.call(this, newMode, this.mode);
        }
      }
      this.mode = newMode;
      this.$el.attr("data-codesync-mode", this.mode.id);
      if (((_ref1 = this.mode) != null ? _ref1.get : void 0) != null) {
        this.codeMirror.setOption('mode', this.mode.get("codeMirrorMode"));
        this.currentDocument.set('mode', this.mode.id);
        this.currentDocument.set('extension', CodeSync.Modes.guessExtensionFor(this.mode.id));
      }
      return this;
    },
    setCodeMirrorOptions: function(options) {
      var option, value, _results;
      if (options == null) {
        options = {};
      }
      _results = [];
      for (option in options) {
        value = options[option];
        _results.push(this.codeMirror.setOption(option, value));
      }
      return _results;
    },
    setupToolbar: function() {
      if (!this.enableToolbar) {
        this.$('.toolbar-wrapper').hide();
      }
      if (this.hideable === true) {
        return this.$('.toolbar-wrapper').append("<div class='button hide-button'>Hide</div>");
      }
    },
    getDefaultDocument: function() {
      var defaultDocument, defaultOptions, options;
      defaultOptions = {
        mode: this.options.startMode || CodeSync.get("defaultFileType"),
        sticky: true,
        doNotSave: true,
        name: this.defaultDocumentName || "codesync",
        display: "CodeSync"
      };
      options = _.extend(defaultOptions, this.document);
      return defaultDocument = new CodeSync.Document(options);
    },
    loadDefaultDocument: function() {
      return this.documentManager.openDocument(this.getDefaultDocument(), this);
    },
    loadDocument: function(doc) {
      var current;
      if (current = this.currentDocument) {
        current.off("status", this.showStatusMessage);
        current.off("change:compiled", this.applyDocumentContentToPage);
        current.off("change:mode", this.applyDocumentContentToPage, this);
        this.previousDocument = current;
      } else {
        this.trigger("initial:document:load", this.currentDocument = doc);
      }
      doc.on("status", this.showStatusMessage, this);
      doc.on("change:compiled", this.applyDocumentContentToPage, this);
      doc.on("change:mode", this.syncEditorModeWithDocument, this);
      this.codeMirror.swapDoc(doc.toCodeMirrorDocument());
      this.trigger("document:loaded", doc, this.previousDocument);
      this.setCodeMirrorOptions(doc.toCodeMirrorOptions());
      return this.currentDocument = doc;
    },
    syncEditorModeWithDocument: function() {
      if ((this.currentDocument != null) && (this.currentDocument.toMode() !== this.mode)) {
        return this.setMode(this.currentDocument.toMode());
      }
    },
    applyDocumentContentToPage: function() {
      var _ref,
        _this = this;
      return (_ref = this.currentDocument) != null ? _ref.loadInPage({
        complete: function() {
          var _ref1, _ref2;
          if (_this.currentDocument.type() === "script" || _this.currentDocument.type() === "template") {
            if ((_ref1 = CodeSync.onScriptChange) != null) {
              _ref1.call(window, _this.currentDocument.attributes);
            }
          }
          if (_this.currentDocument.type() === "stylesheet") {
            if ((_ref2 = CodeSync.onStylesheetChange) != null) {
              _ref2.call(window, _this.currentDocument.attributes);
            }
          }
          _this.trigger("code:sync", _this.currentDocument);
          return _this.trigger("code:sync:" + (_this.currentDocument.type()), _this.currentDocument, typeof JST !== "undefined" && JST !== null ? JST[_this.currentDocument.nameWithoutExtension()] : void 0);
        }
      }) : void 0;
    },
    removeStatusMessages: function() {
      return this.$('.status-message').remove();
    },
    showError: function(message) {
      return this.showStatusMessage({
        type: "error",
        message: message
      });
    },
    showStatusMessage: function(options) {
      var allowedTypes, _ref,
        _this = this;
      if (options == null) {
        options = {};
      }
      this.removeStatusMessages();
      allowedTypes = (function() {
        switch (this.enableStatusMessages) {
          case false:
            return [];
          case true:
          case "all":
            return ["success", "error", "notice"];
          default:
            return [this.enableStatusMessages];
        }
      }).call(this);
      if (!(_(allowedTypes).indexOf(options.type) >= 0)) {
        return;
      }
      if (((_ref = options.message) != null ? _ref.length : void 0) > 0) {
        this.$el.prepend("<div class='status-message " + options.type + "'>" + options.message + "</div>");
      }
      if (options.type === "success") {
        return _.delay(function() {
          return _this.$('.status-message.success').animate({
            opacity: 0
          }, {
            duration: 400,
            complete: function() {
              return _this.$('.status-message.success').remove();
            }
          });
        }, 1200);
      }
    },
    hintHeight: function() {
      var offset;
      return offset = this.showVisibleTab ? this.$('.document-tabs-container').height() : 0;
    },
    visibleStyleSettings: function() {
      var settings;
      if (this.position === "static") {
        settings = {};
      }
      if (this.position === "top") {
        settings = {
          top: '0px'
        };
      }
      if (this.position === "bottom") {
        settings = {
          bottom: '0px',
          height: '400px'
        };
      }
      return settings;
    },
    hiddenStyleSettings: function() {
      var settings;
      if (this.position === "static") {
        settings = {};
      }
      if (this.position === "top") {
        settings = {
          top: ((this.$el.height() + 8) * -1) + this.hintHeight(),
          bottom: 'auto'
        };
      }
      if (this.position === "bottom") {
        settings = {
          bottom: '0px',
          height: "" + (this.hintHeight() - 8) + "px"
        };
      }
      return settings;
    },
    hide: function(withEffect) {
      var completeFn, view, viewName, _ref,
        _this = this;
      if (withEffect == null) {
        withEffect = true;
      }
      console.trace();
      this.animating = true;
      _ref = this.views;
      for (viewName in _ref) {
        view = _ref[viewName];
        view.trigger("editor:hidden");
      }
      if (this.hideable) {
        this.$el.removeAttr('data-visible');
      }
      completeFn = _.debounce(function() {
        _this.visible = false;
        return _this.animating = false;
      }, this.effectDuration + 20);
      if (withEffect !== false) {
        this.$el.animate(this.hiddenStyleSettings(), {
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
      if (this.hideable) {
        this.$el.attr('data-visible', true);
      }
      completeFn = _.debounce(function() {
        _this.visible = true;
        return _this.animating = false;
      }, this.effectDuration);
      if (withEffect !== false) {
        this.$el.removeAttr('style').css('top', '').css('bottom', '');
        this.$el.animate(this.visibleStyleSettings(), {
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
    }
  });

  CodeSync.AssetEditor.instances = {};

  CodeSync.commands = {
    commandOne: function() {},
    commandTwo: function() {},
    commandThree: function() {}
  };

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
    CodeSync.set("editorToggleHotkey", hotKey);
    return key(hotKey, function() {
      return CodeSync.AssetEditor.toggleEditor(options);
    });
  };

}).call(this);
(function() {



}).call(this);
(function() {



}).call(this);
