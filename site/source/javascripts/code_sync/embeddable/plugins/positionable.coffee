CodeSync.plugins.Positionable =
  setup: (embeddable, options)->
    embeddable.position =  {}
    embeddable.$el.addClass('visible')

    set = (option)->
      # fuck it
      height  = (@positionableElement || @$el).height()
      width  = (@positionableElement || @$el).width()

      embeddable.$el.attr 'data-position', option

      el = (@positionablElement || @$el)

      switch option
        when "bottom"
          el.css
            position: 'fixed'
            bottom: "0px"
            left: '50%'
            "margin-left": 0.5 * width * -1

        when "top"
          el.css
            position: 'fixed'
            top: "0px"
            left: '50%'
            "margin-left": 0.5 * width * -1

        when "draggable"
          el.css
            left: '50%'
            "margin-left": 0.5 * width * -1

          (@draggableElement || @positionableElement).draggable(handle: ".drag-handle")


    embeddable.position.set = (option)->
      set.call(embeddable, option)
