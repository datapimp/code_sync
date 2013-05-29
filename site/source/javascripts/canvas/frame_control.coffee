CodeSync.FrameControl = Backbone.View.extend
  events:
    "click .back-button":             "backButton"
    "click .forward-button":          "forwardButton"
    "click .refresh-button":          "forwardButton"
    "click .toggle-control":          "toggleControl"
    "keypress .input-wrapper input":  "handleInput"

  backButton: ()->
    @frame.contentWindow.history.back()

  forwardButton: ()->
    @frame.contentWindow.history.forward()

  refreshButton: ()->
    @frame.contentWindow.location.reload(true)

  toggleControl: ()->
    if @$('.menu').is(":visible")
      @$('.menu').hide()
      @$('.button').show()
    else
      @$('.menu').show()
      @$('.button').hide()

  handleInput: (e)->
    url = @getUrlValue()
    @setUrlValue(url, true)

  setUrlValue: (value, setLocation=false)->
    @$('.input-wrapper input').val(value)
    @frame.contentWindow.location = value if value && setLocation

  getUrlValue: ()->
    @$('.input-wrapper input').val()

  getCanvasUrl: ()->
    location    = @frame?.contentWindow.location
    url         = location.href.replace(location.origin, '')
    [url,query] = url.split('?')

    url

  render: ()->
    html = CodeSync.template("url_control",url:"#{ @getCanvasUrl() }")
    @$el.html(html)

    @

  initialize: (options={})->
    @frame      = options.frame
    @existing   = options.el

    throw "Must pass in a frame to the frame control" unless @frame

    @handleInput = _.debounce(@handleInput,500)

    Backbone.View::initialize.apply(@, arguments)
