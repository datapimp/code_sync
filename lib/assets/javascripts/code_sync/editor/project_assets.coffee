CodeSync.ProjectAssets = Backbone.Collection.extend
  url: ()->
    "http://localhost:9295/info"

  parse: (response)->
    models = for path in _.uniq(response.project_assets)
      description = path.replace(response.root,'')
      {path,description}

    models

  initialize: ()->
    @fetch()
    Backbone.Collection::initialize.apply(@, arguments)