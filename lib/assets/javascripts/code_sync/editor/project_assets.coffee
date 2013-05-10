CodeSync.ProjectAssets = Backbone.Collection.extend
  url: ()->
    CodeSync.get("serverInfoEndpoint")

  parse: (response)->
    models = for path in _.uniq(response.project_assets)
      description = path.replace(response.root,'')
      {path,description}

    models

  initialize: ()->
    @fetch()
    Backbone.Collection::initialize.apply(@, arguments)