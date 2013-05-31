CodeSync.ProjectAssets = Backbone.Collection.extend
  model: CodeSync.Document

  url: CodeSync.get("serverInfoEndpoint")

  parse: (response)->
    response.project_assets

  findDocumentByPath: (path)->
    @detect (model)->
      model.get('path') is path
