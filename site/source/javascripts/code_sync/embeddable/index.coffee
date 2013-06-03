#= require_tree ./templates
#= require ./panel
#= require ./view

#= require_self

CodeSync.Embeddable =
  instances: {}

CodeSync.Embeddable.createIn = (container, options={})->
  container = $(container)

  container.addClass("layout-visualization")

  if existing = container.data('embeddable-instance')
    existing = CodeSync.Embeddable.instances[existing]
    existing?.remove()

    delete CodeSync.Embeddable.instances[existing]

  embeddable = new CodeSync.EmbeddableView(options)
  embeddable.renderIn(container)

  CodeSync.Embeddable.instances[embeddable.cid] = embeddable

  embeddable
