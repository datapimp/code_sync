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
