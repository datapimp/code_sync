CodeSync.SlideDrawer =

  setPosition: (@position="top", show=true)->
    for available in ["top","bottom","static"] when available isnt @position
      @$el.removeClass("#{ available }-positioned")

    @$el.addClass("#{ @position }-positioned")
    @$el.removeAttr('style')

    @show() if show is true

    @

  setHeight: (@height, show=true)->
    if _.isNumber(@height)
      @height = "#{ @height }px"

    @$el.css('height', @height)
    @$el.addClass('static-height')

  hintHeight: ()->
    offset = if @showVisibleTab then @$('.document-tabs').height() else 0

  visibleStyleSettings: ()->
    if @position is "static"
      settings = {}

    if @position is "top"
      settings =
        top: '0px'

    if @position is "bottom"
      settings =
        bottom: '0px'
        height: @height

    settings

  hiddenStyleSettings: ()->
    if @position is "static"
      settings = {}

    if @position is "top"
      settings =
        top: @$('.codemirror-wrapper').height() * -1
        bottom: 'auto'

    if @position is "bottom"
      settings =
        bottom: '0px'
        height: @height - @$('.document-tabs').height()

    settings

  hide: (withEffect=true)->
    console.trace()

    @animating = true

    view.trigger("editor:hidden") for viewName, view of @views
    @$el.removeAttr('data-visible') if @hideable

    completeFn = _.debounce ()=>
      @visible = false
      @animating = false
    , @effectDuration + 20

    if withEffect isnt false
      @$el.animate @hiddenStyleSettings(), duration: @effectDuration, complete: completeFn
      _.delay(completeFn, @effectDuration)
    else
      completeFn()

    @

  show: (withEffect=true)->
    @setupCodeMirror()

    @animating = true

    view.trigger("editor:visible") for viewName, view of @views
    @$el.attr('data-visible',true) if @hideable

    completeFn = _.debounce ()=>
      @visible = true
      @animating = false
    , @effectDuration

    if withEffect isnt false
      @$el.removeAttr('style').css('top','').css('bottom','')
      @$el.animate @visibleStyleSettings(), duration: @effectDuration, complete: completeFn
      _.delay(completeFn, @effectDuration)
    else
      completeFn()

    @

  toggle: ()->
    return if @animating is true

    if @visible is true
      @hide(true)
    else
      @show(true)
