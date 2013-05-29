CodeSync.toolbars ||= {}

CodeSync.toolbars.CanvasToolbar = Backbone.View.extend
  className: "codesync-canvas-toolbar"

  events:
    "click .controls li[data-option]" : "adjustSetting"

  initialize: (@options={})->
    _.extend(@, @options)
    Backbone.View::initialize.apply(@, arguments)

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

