(function($) {

/* AnsiParse */
ansiparse = function (str) {
  //
  // I'm terrible at writing parsers.
  //
  var matchingControl = null,
      matchingData = null,
      matchingText = '',
      ansiState = [],
      result = [],
      state = {},
      eraseChar;

  //
  // General workflow for this thing is:
  // \033\[33mText
  // |     |  |
  // |     |  matchingText
  // |     matchingData
  // matchingControl
  //
  // In further steps we hope it's all going to be fine. It usually is.
  //

  //
  // Erases a char from the output
  //
  eraseChar = function () {
    var index, text;
    if (matchingText.length) {
      matchingText = matchingText.substr(0, matchingText.length - 1);
    }
    else if (result.length) {
      index = result.length - 1;
      text = result[index].text;
      if (text.length === 1) {
        //
        // A result bit was fully deleted, pop it out to simplify the final output
        //
        result.pop();
      }
      else {
        result[index].text = text.substr(0, text.length - 1);
      }
    }
  };

  for (var i = 0; i < str.length; i++) {
    if (matchingControl != null) {
      if (matchingControl == '\u001B' && str[i] == '\[') {
        //
        // We've matched full control code. Lets start matching formating data.
        //

        //
        // "emit" matched text with correct state
        //
        if (matchingText) {
          state.text = matchingText;
          result.push(state);
          state = {};
          matchingText = "";
        }

        matchingControl = null;
        matchingData = '';
      }
      else {
        //
        // We failed to match anything - most likely a bad control code. We
        // go back to matching regular strings.
        //
        matchingText += matchingControl + str[i];
        matchingControl = null;
      }
      continue;
    }
    else if (matchingData != null) {
      if (str[i] == ';') {
        //
        // `;` separates many formatting codes, for example: `\033[33;43m`
        // means that both `33` and `43` should be applied.
        //
        // TODO: this can be simplified by modifying state here.
        //
        ansiState.push(matchingData);
        matchingData = '';
      }
      else if (str[i] == 'm') {
        //
        // `m` finished whole formatting code. We can proceed to matching
        // formatted text.
        //
        ansiState.push(matchingData);
        matchingData = null;
        matchingText = '';

        //
        // Convert matched formatting data into user-friendly state object.
        //
        // TODO: DRY.
        //
        ansiState.forEach(function (ansiCode) {
          if (ansiparse.foregroundColors[ansiCode]) {
            state.foreground = ansiparse.foregroundColors[ansiCode];
          }
          else if (ansiparse.backgroundColors[ansiCode]) {
            state.background = ansiparse.backgroundColors[ansiCode];
          }
          else if (ansiCode == 39) {
            delete state.foreground;
          }
          else if (ansiCode == 49) {
            delete state.background;
          }
          else if (ansiparse.styles[ansiCode]) {
            state[ansiparse.styles[ansiCode]] = true;
          }
          else if (ansiCode == 22) {
            state.bold = false;
          }
          else if (ansiCode == 23) {
            state.italic = false;
          }
          else if (ansiCode == 24) {
            state.underline = false;
          }
        });
        ansiState = [];
      }
      else {
        matchingData += str[i];
      }
      continue;
    }

    if (str[i] == '\u001B') {
      matchingControl = str[i];
    }
    else if (str[i] == '\u0008') {
      eraseChar();
    }
    else {
      matchingText += str[i];
    }
  }

  if (matchingText) {
    state.text = matchingText + (matchingControl ? matchingControl : '');
    result.push(state);
  }
  return result;
}

ansiparse.foregroundColors = {
  '30': 'black',
  '31': 'red',
  '32': 'green',
  '33': 'yellow',
  '34': 'blue',
  '35': 'magenta',
  '36': 'cyan',
  '37': 'white',
  '90': 'grey'
};

ansiparse.backgroundColors = {
  '40': 'black',
  '41': 'red',
  '42': 'green',
  '43': 'yellow',
  '44': 'blue',
  '45': 'magenta',
  '46': 'cyan',
  '47': 'white'
};

ansiparse.styles = {
  '1': 'bold',
  '3': 'italic',
  '4': 'underline'
};

if (typeof module == "object" && typeof window == "undefined") {
  module.exports = ansiparse;
}

/* app */
  var webconsole = {
    history:[],
    pointer:0,
    query:$('#webconsole_query')
  }

  $('#rack-webconsole form').submit(function(e){
    console.log("prevent default submit on for")
    e.preventDefault();
  });

  // colors
  var colors = {
    'black': "#eeeeee",
    'red': "#ff6c60",
    'green': "#a8ff60",
    'yellow': "#ffffb6",
    'blue': "#96cbfe",
    'magenta': "#ff73fd",
    'cyan': "#c6c5fe",
    'white': "#eeeeee"
  }
  var boldColors = {
    'black': "#7c7c7c",
    'red': "#ffb6b0",
    'green': "#ceffac",
    'yellow': "#ffffcb",
    'blue': "#b5dcfe",
    'magenta': "#ff9cfe",
    'cyan': "#dfdffe",
    'white': "#ffffff"
  }

  function subColor(color, elem)
  {
    if (color == undefined) color = 'white';
    if (elem.bold && boldColors[color] != undefined) {
      color = boldColors[color];
    } else if (!elem.bold && colors[color] != undefined) {
      color = colors[color];
    }
    return color;
  }
  function parseBashString(str, into)
  {
    $.each(ansiparse(str), function(idx, elem) {
      if (elem.text.length == 1 && elem.text[0] == '\n') {
        into.append("<br>");
        return true;
      }
      var domElem = $('<span></span>');
      domElem.text(elem.text);
      domElem.html(domElem.text().replace(/\n/g, "<br>"));
      domElem.css('color', subColor(elem.foreground, elem));
      if (elem.bold)
        domElem.css('font-weight', 'bold');
      if (elem.italic)
        domElem.css('font-style', 'italic');
      if (elem.underline)
        domElem.css('text-decoration', 'underline');
      if (elem.background)
        domElem.css('background-color', subColor(elem.background, elem));
      into.append(domElem);
    });
  }
  $("#rack-webconsole form input").keyup(function(event) {
    function escapeHTML(string) {
      return(string.replace(/&/g,'&amp;').
        replace(/>/g,'&gt;').
        replace(/</g,'&lt;').
        replace(/"/g,'&quot;')
      );
    };

    // enter
    if (event.which == 13) {
      webconsole.history.push(webconsole.query.val());
      webconsole.pointer = webconsole.history.length - 1;
      $.ajax({
        url: CodeSync.get("consolePath"),
        type: 'POST',
        dataType: 'json',
        data: ({query: webconsole.query.val(), token: "$TOKEN"}),
        success: function (data) {
          console.log("data",data);
          var query_class = data.previous_multi_line ? 'query_multiline' : 'query';
          var result = $("<div class='" + query_class + "'></div>");
          parseBashString(escapeHTML(data.prompt), result);
          if (!data.multi_line) {
            var mresult = $("<div class='result'></div>");
            parseBashString(escapeHTML(data.result), mresult);
            result.append(mresult);
          }
          $("#rack-webconsole .results").append(result);
          $("#rack-webconsole .results_wrapper").scrollTop(
            $("#rack-webconsole .results").height()
          );
        }
      });
      webconsole.query.val('');
    }

    // up
    if (event.which == 38) {
      if (webconsole.pointer < 0) {
        webconsole.query.val('');
      } else {
        if (webconsole.pointer == webconsole.history.length) {
          webconsole.pointer = webconsole.history.length - 1;
        }
        webconsole.query.val(webconsole.history[webconsole.pointer]);
        webconsole.pointer--;
      }
    }

    // down
    if (event.which == 40) {
      if (webconsole.pointer == webconsole.history.length) {
        webconsole.query.val('');
      } else {
        if (webconsole.pointer < 0) {
          webconsole.pointer = 0;
        }
        webconsole.query.val(webconsole.history[webconsole.pointer]);
        webconsole.pointer++;
      }
    }

  });

  $(document).ready(function() {
    $(this).keypress(function(event) {

      if ($KEY_CODE.indexOf(event.which) >= 0) {
        $("#rack-webconsole").slideToggle('fast', function() {
          if ($(this).is(':visible')) {
            $("#rack-webconsole form input").focus();
            $("#rack-webconsole .results_wrapper").scrollTop(
              $("#rack-webconsole .results").height()
            );
          } else {
            $("#rack-webconsole form input").blur();
          }
        });
        event.preventDefault();
      }
    });
  });
})(jQuery);
