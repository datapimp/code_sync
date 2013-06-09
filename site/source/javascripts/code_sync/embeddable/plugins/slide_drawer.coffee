CodeSync.plugins.SlideDrawer =
  setup: (embeddable,options)->
    el = embeddable.$el
    embeddable.visible = true

    embeddable.height = el.height()

    embeddable.events["click .visibility-handle"] = ()->
      action    = if embeddable.visible is true then "hide" else "show"
      handler   = embeddable.$el.attr('data-position')
      helpers[handler].call(embeddable, action)

    embeddable.delegateEvents()

helpers =
  bottom: (action="show")->
    el = @$el
    embeddable = @

    if action is "show"
      el.animate {'bottom': 0, height: embeddable.height}, complete: ()->
        embeddable.visible = true
        el.addClass('visible')
    else if action is "hide"
      el.animate {'bottom': 0, height: 0}, complete: ()->
        embeddable.visible = false
        el.removeClass('visible')

  top: (action="show")->
    el = @$el
    embeddable = @

    height = el.height()

    if action is "show"
      el.animate {'top': 0}, complete: ()->
        embeddable.visible = true
        el.addClass('visible')
    else if action is "hide"
      el.animate {'top': ((height * -1) + 25 )}, complete: ()->
        embeddable.visible = false
        el.removeClass('visible')
