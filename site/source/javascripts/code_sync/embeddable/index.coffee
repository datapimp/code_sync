#= require_tree ./templates
#= require ./panel
#= require ./view
#= require ./plugins/embeddable_preferences
#= require ./plugins/resizable
#= require ./plugins/file_controls
#= require ./plugins/mode_selector
#= require ./plugins/element_sync
#= require ./plugins/positionable
#= require ./plugins/slide_drawer


#= require_self

CodeSync.Embeddable =
  instances: {}

CodeSync.Embeddable.createIn = (container, options={})->
  container = $(container)

  container.addClass("layout-visualization")

  if options.width
    container.css('width', options.width)

  if options.empty
    container.empty()

  if existing = container.data('embeddable-instance')
    existing = CodeSync.Embeddable.instances[existing]
    existing?.remove()

    delete CodeSync.Embeddable.instances[existing]

  embeddable = new CodeSync.EmbeddableView(options)
  embeddable.renderIn(container, options)

  embeddable.draggableElement = container unless container.is('body')
  embeddable.positionableElement = container unless container.is('body')

  CodeSync.Embeddable.instances[embeddable.cid] = embeddable

  embeddable

