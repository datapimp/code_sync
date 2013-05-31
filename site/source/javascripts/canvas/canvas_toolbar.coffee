CodeSync.toolbars ||= {}

CodeSync.toolbars.CanvasToolbar = Backbone.View.extend
  className: "codesync-canvas-toolbar"

  events:
    "click .controls li[data-option]"     : "adjustSetting"
    "click a.toggle-stylesheet-loader"    : "toggleStylesheetLoader"
    "click a.toggle-script-loader"        : "toggleScriptLoader"
    "click .toggle-custom-layout"         : "toggleCustomLayout"
    "click .toggle-document-browser"      : "toggleDocumentBrowser"

  initialize: (@options={})->
    _.extend(@, @options)
    Backbone.View::initialize.apply(@, arguments)

  toggleStylesheetLoader: (e)->
    button = @$(e.target)

    @styleLoader ||= new CodeSync.plugins.StylesheetLoader
      alignment: "bottom"

      checkAvailabilityInMode: ->
        true

      getWindow: ()=>
        @editorPanel?.getWindow()

      renderTo: ()=>
        @editorPanel.$el

    @styleLoader.toggle(withEffect: true)

  toggleScriptLoader: (e)->
    button = @$(e.target)

    @scriptLoader ||= new CodeSync.plugins.ScriptLoader
      alignment: "bottom"

      checkAvailabilityInMode: ->
        true

      getWindow: ()=>
        @editorPanel?.getWindow()

      renderTo: ()=>
        @editorPanel.$el

    @scriptLoader.toggle(withEffect: true)

  toggleCustomLayout: ()->

  toggleDocumentBrowser: ()->

  adjustSetting: (e)->
    $target   = @$(e.target).closest('li[data-option]')
    siblings  = $target.siblings('li[data-option]')
    control   = $target.parents('.controls').eq(0)
    value     = $target.data('option')
    setting   = control.data('setting')

    siblings.removeClass('active')
    $target.addClass('active')

    @editorPanel.set(setting, value)

  render: ()->
    @$el.html CodeSync.template("canvas_toolbar")
    @

