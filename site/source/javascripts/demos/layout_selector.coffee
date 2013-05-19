window.LayoutSelector = Backbone.View.extend
  id: "layout-selector"
  tagName: "ul"

  events:
    "click .opt1": ()->
      $('.editor-container').attr('data-layout','one')

    "click .opt2": ()->
      $('.editor-container').attr('data-layout','two')

    "click .opt3": ()->
      $('.editor-container').attr('data-layout','three')

  render: ()->
    for n in [1,2,3]
      @$el.append "<li class='opt#{n}'>#{n}</li>"

    @