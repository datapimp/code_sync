CodeSync.LayerController = Backbone.View.extend
  events:
    "dblclick .horizontal-handle" : "snapBackLeft"
    "dblclick .vertical-handle" : "snapBackUp"

  initialize: (@options={})->
    _.extend(@,@options)

    Backbone.View::initialize.apply(@, arguments)

    @setElement $(@applyTo)
    @render()

  render: ()->
    @makeDraggable("vertical")
    @

  snapBackLeft: ()->
    @$el.animate('left':'0px')

  snapBackUp: ()->
    @$el.animate('top':'0px')

  enableVerticalDragging: ()->
    @makeDraggable("vertical")

  enableHorizontalDragging: ()->
    @makeDraggable("horizontal")

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
