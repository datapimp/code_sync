CodeSync.tour =
  step: 0

make = (tagName, attributes, content)->
  el = document.createElement(tagName);
  if (attributes)
    Backbone.$(el).attr(attributes)
  if (content != null)
    Backbone.$(el).html(content)

  el

showBubble = (content,position={})->
  positionStyle = "position: absolute;"

  for k,v of position when v?
    v = "#{ v }px" unless "#{ v }".match(/px/)
    positionStyle += "#{ k }:#{ v };"

  bubble = make("div",{class:"bubble",style:positionStyle}, content)

  $(".next", bubble).on "click", ()->
    $('body .bubble').addClass('animated bounceOutRight')
    CodeSync.startTour(next: true)

  $('body').append(bubble)

  $(bubble)

CodeSync.enableTour = ()->
  $('.tour-button').off "click"
  $('.tour-button').on "click", ()->
    $(@).addClass("animated fadeOut")
    CodeSync.startTour(restart:true)

CodeSync.startTour = (options={})->
  if $('.codesync-tour-content').length is 0
    $('body').append JST["demos/tour"]()

  if options.restart is true
    CodeSync.tour.step = 0

  if options.next is true
    CodeSync.tour.step = CodeSync.tour.step + 1

  nextStep = CodeSync.tour.step
  tourData = $(".codesync-tour-content .content[data-tour-step=#{ nextStep }]")

  if tourData.length > 0
    bubbleContent = tourData[0].outerHTML

    orientation = tourData.data('position') || "below"
    transition = if orientation is "below" then "bounceInDown" else "bounceInUp"
    target = tourData.data('target')

    if $(target).length > 0
      currentPos = $(target).position()
      if orientation is "below"
        top = currentPos.top + $(target).height() + 25
        left = currentPos.left + 80
      else
        bottom = "120px"
        right = "15px"
    else
      top = "600px"
      left = "600px"

    bubbleElement = showBubble(bubbleContent,{top,left,bottom,right})

    bubbleElement.addClass("animated #{ transition }")
