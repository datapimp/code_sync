
CodeSync.plugins.Resizable= setup: (embeddable)->
  embeddable.on "ready", ->
    embeddable.$el.resizable({ handles: "n, e, s, w" });
