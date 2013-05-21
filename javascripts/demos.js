(function() {

  window.coffeescriptDefault = "# This coffeescript content will be automatically evaluated any time you\n# change some stuff.\nCodeSync.onScriptChange ||= (changeObject)->\n  if changeObject.mode is \"skim\" and changeObject.name is \"codesync\"\n    $(\".canvas-container\").html JST[\"codesync\"]()\n\n(CodeSync.tour ||= {}).step = 0\nCodeSync.enableTour(restart: true)";

  window.skimDefault = ".editor-demos\n  h1 CodeSync Editor Demos\n  p\n    | You can embed as many CodeSync.AssetEditor as you want in any configuration you want, and they will hook right up to the asset pipeline in your project and allow you to use your assets to create a little front end development canvas.\n  p\n    | In this example here, I am using a CodeSync.onScriptChange hook to wire up the automatic rendering of a template file whenever it changes, to display the contents of that template as it would be styled in my project.\n\n  h2.tour-button Click Here to take a tour son";

  window.scssDefault = "/* scss */\n\n@import url(http://fonts.googleapis.com/css?family=Lobster|Raleway);\n\nbody {\n  font-family: \"Raleway\";\n  background: #656892;\n  color: #ffffff;\n}\n\n.bubble {\n  width: 250px;\n  background-color: rgba(30,30,30,0.75);\n  border-radius: 12px;\n  padding: 12px;\n  box-shadow: 0 0 6px #000000;\n  h4 {\n    font-family: \"Lobster\";\n    text-align: center;\n  }\n\n  a.next {\n    font-family: \"Lobster\";\n  display: block;\n    text-align: right;\n    cursor: pointer;\n  }\n}\n\n.editor-demos {\n  padding-left: 20px;\n  p {\n    max-width: 600px;\n  }\n  h1,h2 {\n    font-family: \"Lobster\";\n    text-shadow: 3px 6px #333333;\n    font-weight: 400;\n  }\n  h1 {\n    font-size: 88px;\n  }\n  h2 {\n    font-size: 48px;\n    cursor: pointer;\n    text-shadow: 2px 4px #333333;\n  }\n}";

}).call(this);
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
(function() {
  var make, showBubble;

  CodeSync.tour = {
    step: 0
  };

  make = function(tagName, attributes, content) {
    var el;
    el = document.createElement(tagName);
    if (attributes) {
      Backbone.$(el).attr(attributes);
    }
    if (content !== null) {
      Backbone.$(el).html(content);
    }
    return el;
  };

  showBubble = function(content, position) {
    var bubble, k, positionStyle, v;
    if (position == null) {
      position = {};
    }
    positionStyle = "position: absolute;";
    for (k in position) {
      v = position[k];
      if (!(v != null)) {
        continue;
      }
      if (!("" + v).match(/px/)) {
        v = "" + v + "px";
      }
      positionStyle += "" + k + ":" + v + ";";
    }
    bubble = make("div", {
      "class": "bubble",
      style: positionStyle
    }, content);
    $(".next", bubble).on("click", function() {
      $('body .bubble').addClass('animated bounceOutRight');
      return CodeSync.startTour({
        next: true
      });
    });
    $('body').append(bubble);
    return $(bubble);
  };

  CodeSync.enableTour = function() {
    $('.tour-button').off("click");
    return $('.tour-button').on("click", function() {
      $(this).addClass("animated fadeOut");
      return CodeSync.startTour({
        restart: true
      });
    });
  };

  CodeSync.startTour = function(options) {
    var bottom, bubbleContent, bubbleElement, currentPos, left, nextStep, orientation, right, target, top, tourData, transition;
    if (options == null) {
      options = {};
    }
    if ($('.codesync-tour-content').length === 0) {
      $('body').append(JST["demos/tour"]());
    }
    if (options.restart === true) {
      CodeSync.tour.step = 0;
    }
    if (options.next === true) {
      CodeSync.tour.step = CodeSync.tour.step + 1;
    }
    nextStep = CodeSync.tour.step;
    tourData = $(".codesync-tour-content .content[data-tour-step=" + nextStep + "]");
    if (tourData.length > 0) {
      bubbleContent = tourData[0].outerHTML;
      orientation = tourData.data('position') || "below";
      transition = orientation === "below" ? "bounceInDown" : "bounceInUp";
      target = tourData.data('target');
      if ($(target).length > 0) {
        currentPos = $(target).position();
        if (orientation === "below") {
          top = currentPos.top + $(target).height() + 25;
          left = currentPos.left + 80;
        } else {
          bottom = "120px";
          right = "15px";
        }
      } else {
        top = "600px";
        left = "600px";
      }
      bubbleElement = showBubble(bubbleContent, {
        top: top,
        left: left,
        bottom: bottom,
        right: right
      });
      return bubbleElement.addClass("animated " + transition);
    }
  };

}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["demos/tour"] = (function() {
  
    return function(context) {
      if (context == null) {
        context = {};
      }
      return Skim.withContext.call({}, context, function() {
        var _buf;
        _buf = [];
        _buf.push("<div class=\"codesync-tour-content\" style=\"display: none\"><div class=\"content\" data-target=\"[data-codesync='panel-1']\" data-tour-step=\"0\"><h4>SCSS Editor</h4><p>This is a SCSS editor.  It allows you to use SCSS or SASS to write some CSS to style the contents of the page.</p><a class=\"next\">Next</a></div><div class=\"content\" data-target=\"[data-codesync='panel-2']\" data-tour-step=\"1\"><h4>Skim Editor</h4><p>This is a Skim template editor.  A CodeSync.onScriptChange hook is wired up so that whenever it changes, the contents will be rendered in the canvas below.</p><a class=\"next\">Next</a></div><div class=\"content\" data-target=\"[data-codesync='panel-3']\" data-tour-step=\"2\"><h4>Coffeescript Editor</h4><p>This is a Coffeescript editor.  The contents of your code will be evaluated and ran as you type.</p><a class=\"next\">Next</a></div><div class=\"content\" data-position=\"above\" data-target=\"#layout-selector\" data-tour-step=\"3\"><h4>Layout Selector</h4><p>This little widget will control the layout of the editors on this page.</p><a class=\"next\">Cool Homie.</a></div></div>");
        return _buf.join('');
      });
    };
  
  }).call(this);;
}).call(this);
(function() {

  window.defaultContentFor = function(mode) {
    return window["" + mode + "Default"];
  };

  window.setupEditors = _.once(function() {
    var index, mode, _i, _len, _name, _ref;
    _ref = ["scss", "skim", "coffeescript"];
    for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
      mode = _ref[index];
      window[_name = "" + mode + "Editor"] || (window[_name] = new CodeSync.AssetEditor({
        hideable: false,
        autoRender: true,
        appendTo: ".editor-container",
        renderVisible: true,
        startMode: mode,
        name: "panel-" + (index + 1),
        position: "static",
        document: {
          content: "shit",
          contents: defaultContentFor(mode)
        },
        plugins: ["ModeSelector", "KeymapSelector"]
      }));
    }
    return scssEditor.addPlugin("ColorPicker");
  });

  setupEditors();

  window.layoutSelector || (window.layoutSelector = new LayoutSelector());

  if (!($('#layout-selector').length > 0)) {
    $('body').append(layoutSelector.render().el);
  }

  CodeSync.onScriptChange || (CodeSync.onScriptChange = function(changeObject) {
    if (changeObject.mode === "skim" && changeObject.name === "codesync") {
      $(".canvas-container").html(JST["codesync"]());
      return window.coffeescriptEditor.currentDocument.trigger("change:contents");
    }
  });

  _.delay(function() {
    window.skimEditor.currentDocument.trigger("change:contents");
    return window.scssEditor.currentDocument.trigger("change:contents");
  }, 600);

  _.delay(function() {
    window.coffeescriptEditor.currentDocument.trigger("change:contents");
    return window.enableGlobalEditor();
  }, 1800);

}).call(this);
