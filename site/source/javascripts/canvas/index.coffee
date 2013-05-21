CodeSync.Canvas = Backbone.View.extend
  events:
    "click .horizontal-handle" : "enableHorizontalDragging"
    "click .vertical-handle" : "enableVerticalDragging"
    "dblclick .horizontal-handle" : "snapBackLeft"
    "dblclick .vertical-handle" : "snapBackUp"

  initialize: ()->
    Backbone.View::initialize.apply(@, arguments)
    @render()

  render: ()->
    @setElement $('#canvas-panel')
    @

  snapBackLeft: ()->
    @$el.animate('left':'0px')

  snapBackUp: ()->
    @$el.animate('top':'0px')

  enableVerticalDragging: ()->
    @cancelDraggable() if @direction is "horizontal"
    @makeDraggable("vertical")

  enableHorizontalDragging: ()->
    @cancelDraggable() if @direction is "vertical"
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

$ ->
  window.codeSyncCanvas = new CodeSync.Canvas()
  codeSyncCanvas.makeDraggable("horizontal")
