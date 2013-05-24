CodeSync.LayerController = Backbone.View.extend
  events:
    "dblclick .horizontal-handle" : "snapBackLeft"
    "dblclick .vertical-handle" : "snapBackUp"
    "click .horizontal-handle": "enableHorizontalDragging"
    "click .vertical-handle": "enableVerticalDragging"

  initialize: (@options={})->
    _.extend(@,@options)

    Backbone.View::initialize.apply(@, arguments)

    @setElement $(@applyTo)

    @enableVerticalDragging       = _.debounce(@enableVerticalDragging, 25)
    @enableHorizontalDragging     = _.debounce(@enableHorizontalDragging, 25)

    @render()

  render: ()->
    @makeDraggable("vertical")
    @

  snapBackLeft: ()->
    @$el.animate('left':'0px')
    @cancelDraggable()

  snapBackUp: ()->
    @$el.animate('top':'0px')
    @cancelDraggable()

  enableVerticalDragging: ()->
    @makeDraggable("vertical") unless @direction is "vertical"

  enableHorizontalDragging: ()->
    @makeDraggable("horizontal") unless @direction is "horizontal"

  cancelDraggable: ()->
    @direction = undefined
    @$el.draggable('destroy')

  makeDraggable: (@direction="horizontal")->
    @$el.attr('data-draggable-direction', @direction)

    if @direction is "horizontal"
      @$el.draggable
        axis: "x"
        handle: ".horizontal-handle"
        containment:[0,0]

    if @direction is "vertical"
      @$el.draggable
        axis: "y"
        handle: ".vertical-handle"
        containment:[0,0]
