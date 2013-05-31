#= require_tree ./templates
#= require ./layer_controller
#= require ./frame_control
#= require ./canvas_toolbar

#= require_self

original = CodeSync.processChangeNotification

CodeSync.Canvas = Backbone.View.extend
  className: "codesync-canvas"

  target: "canvas"

  getFrameWindow: ()->
    @getFrame()?.contentWindow

  getFrame: ()->
    $('.canvas-frame')[0]

  refreshEditors: ()->
    @editorPanel.each (editor,index)->
      _.delay ()->
        editor.currentDocument.trigger "change:contents"
      , 400 * (index + 1)

  refreshStyleEditor: ()->
    @getEditor("style_editor").currentDocument.trigger "change:contents"

  refreshScriptEditor: ()->
    @getEditor("script_editor").currentDocument.trigger "change:contents"

  refreshTemplateEditor: ()->
    @getEditor("template_editor").currentDocument.trigger "change:contents"

  getEditor:(name)->
    @editorPanel.assetEditors[name]

  routeEditorOutputToGlobal: ()->
    @editorPanel.targetWindow = window

    @editorPanel.each (editor)=>
      editor.targetWindow = window
      editor.views.elementSync.searchScope = window
      editor.views.elementSync.setValue('')

    CodeSync.Document::changeProcessor = window.CodeSync.processChangeNotification

  routeEditorOutputToCanvas: ()->
    @getFrameWindow().name = "CanvasInner"
    @getFrameWindow().$('body').attr('data-canvas-inner',true)

    frame = @getFrameWindow()

    @editorPanel.targetWindow = frame

    @editorPanel.each (editor)=>
      editor.views.elementSync.searchScope = frame
      editor.targetWindow = frame

      if @autoSyncWithElement?
        editor.views.elementSync.setValue(@autoSyncWithElement)

    CodeSync.Document::changeProcessor = (a, b)=>
      if @target is "app"
        original(a,b)

      # If we're routing stuff to the canvas
      # we also want to process script code globally
      else if @target is "canvas"
        if a.type is "script"
          original(a,b)

        if a.type is "template"
          original(a,b)

        # Now let the canvas process it
        @getFrameWindow().CodeSync.processChangeNotification(a,b)

  routeEditorOutput: (@target)->
    if @target is "app" || @target is "global"
      @routeEditorOutputToGlobal()
    else if @target is "canvas"
      @routeEditorOutputToCanvas()

  render: ()->
    @setElement($('#canvas'))

    @codeSyncCanvas = new CodeSync.LayerController(applyTo:"#canvas")
    @frameControl   = new CodeSync.FrameControl(frame: @getFrame())

    @editorPanel.renderIn $(@editorContainer)

    $('#canvas-url-control').html @frameControl.render().el

    @

  initialize: (@options={})->
    _.extend(@, @options)

    canvas = @

    @editorPanel    = new CodeSync.EditorPanel(toolbarClass:"CanvasToolbar")

    @editorPanel.set = (setting, value)->
      if setting is "target"
        canvas.routeEditorOutput(value)

      CodeSync.EditorPanel::set.apply(@, arguments)

    @editorPanel.on "target:change", @routeEditorOutput, @

    @on "editors:routed", @refreshEditors, @

    @editorPanel.on "editors:loaded", ()->
      _.delay ()->
        canvas.routeEditorOutput(canvas.target)
        _.defer ()-> canvas.trigger "editors:routed"
      , 1000

    Backbone.View::initialize.apply(@, arguments)


CodeSync.Canvas.startApplication ||= (force=false)->
  window.name = "CanvasApp"

  console.log "Restarting App" if force and App?
  window.App = undefined if force and App?

  window.App ||= new CodeSync.Canvas(editorContainer:"#editor")

  console.log "Rendering", App.cid
  App.render()

  $('body').attr('data-canvas-application',true)
  $('#canvas').css('top','520px')


$(CodeSync.Canvas.startApplication)