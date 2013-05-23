#= require_tree .
#= require_self

CodeSync.Canvas = Backbone.View.extend
  className: "codesync-canvas"

CodeSync.Canvas.startApplication = ()->
  $('body').attr('data-canvas-application',true)

  codeSyncCanvas = new CodeSync.LayerController(applyTo:"#canvas")

  CodeSync.canvasEditors()

  CodeSync.PryConsole.renderSingleton("#backend-console-wrapper")

