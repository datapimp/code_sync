CodeSync.plugins.Draggable= setup: (editor)->
  editor.draggableElement ||= editor.$el
  editor.draggableElement.draggable(handle: ".drag-handle")
