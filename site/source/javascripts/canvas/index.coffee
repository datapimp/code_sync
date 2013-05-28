#= require ./layer_controller
#= require_self

original = CodeSync.processChangeNotification

CodeSync.Canvas = Backbone.View.extend
  className: "codesync-canvas"

  target: "canvas"

  getFrame: ()->
    $('.canvas-frame')[0]?.contentWindow

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
    @editorPanel.each (editor)=>
      editor.views.elementSync.searchScope = window
      editor.views.elementSync.setValue('')

    CodeSync.processChangeNotification = original

  routeEditorOutputToCanvas: ()->
    @editorPanel.each (editor)=>
      $('body').attr('data-canvas-application',true)
      @getFrame().$('body').attr('data-canvas-inner',true)

      editor.views.elementSync?.searchScope = frame = @getFrame()

      if @autoSyncWithBodyElement is true
        editor.views.elementSync.setValue 'body[data-canvas-inner]'

    CodeSync.processChangeNotification = (a, b)=>
      console.log @target, a.type

      if @target is "app"
        original(a,b)

      else if @target is "canvas"
        if a.type is "template"
          original(a,b)

        @getFrame().CodeSync.processChangeNotification(a,b)

  routeEditorOutput: (@target)->
    if @target is "global"
      @routeEditorOutputToGlobal()
    else if @target is "canvas"
      @routeEditorOutputToCanvas()

  initialize: (@options={})->
    _.extend(@, @options)
    canvas = @

    @setElement($('#canvas'))
    @codeSyncCanvas = new CodeSync.LayerController(applyTo:"#canvas")

    @editorPanel    = new CodeSync.EditorPanel()

    @editorPanel.on "target:change", @routeEditorOutput, @

    @on "editors:routed", @refreshEditors, @

    @editorPanel.on "editors:loaded", ()->
      _.delay ()->
        canvas.routeEditorOutputToCanvas()
        canvas.trigger "editors:routed"
      , 1000

    @editorPanel.renderIn($("#editor"))

    Backbone.View::initialize.apply(@, arguments)


$ CodeSync.Canvas.startApplication ||= ()->
  window.App = new CodeSync.Canvas()
  $('#canvas').css('top','450px')
