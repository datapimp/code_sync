#= require_tree .
#= require_self

original = CodeSync.processChangeNotification

CodeSync.Canvas = Backbone.View.extend
  className: "codesync-canvas"

  getFrame: ()->
    $('.canvas-frame')[0].contentWindow

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

  routeEditorOutputToCanvas: ()->
    @editorPanel.each (editor)=>
      $('body').attr('data-canvas-application',true)
      @getFrame().$('body').attr('data-canvas-inner',true)

      editor.views.elementSync?.searchScope = frame = @getFrame()

      if @autoSyncWithBodyElement is true
        editor.views.elementSync.setValue 'body[data-canvas-inner]'

    CodeSync.processChangeNotification = (a, b)=>
      original(a, b) unless a.type is "stylesheet"
      @getFrame().CodeSync.processChangeNotification(a,b)

  initialize: (@options={})->
    _.extend(@, @options)
    canvas = @

    @codeSyncCanvas = new CodeSync.LayerController(applyTo:"#canvas")
    @editorPanel    = new CodeSync.EditorPanel()

    @on "editors:routed", @refreshEditors, @

    @editorPanel.on "editors:loaded", ()->
      _.delay ()->
        canvas.routeEditorOutputToCanvas()
        canvas.trigger "editors:routed"
      , 1000

    @editorPanel.renderIn($("#editor"))


CodeSync.Canvas.startApplication = ()->
  window.App = new CodeSync.Canvas()
