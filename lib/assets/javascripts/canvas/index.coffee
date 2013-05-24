#= require_tree .
#= require_self

original = CodeSync.processChangeNotification

CodeSync.Canvas = Backbone.View.extend
  className: "codesync-canvas"

  getFrame: ()->
    $('.canvas-frame')[0].contentWindow

  initialize: (options={})->
    @codeSyncCanvas = new CodeSync.LayerController(applyTo:"#canvas")
    @editorPanel = new CodeSync.EditorPanel()

    @editorPanel.renderIn($("#editor"))

    _.delay ()=>
      @editorPanel.each (editor)=>
        $('body').attr('data-canvas-application',true)
        @getFrame().$('body').attr('data-canvas-inner',true)

        editor.views.elementSync.searchScope = frame = @getFrame()
        editor.views.elementSync.setValue 'body[data-canvas-inner]'

      CodeSync.processChangeNotification = (a, b)=>
        original(a, b) unless a.type is "stylesheet"
        @getFrame().CodeSync.processChangeNotification(a,b)

    , 4000

CodeSync.Canvas.startApplication = ()->
  window.App = new CodeSync.Canvas()

