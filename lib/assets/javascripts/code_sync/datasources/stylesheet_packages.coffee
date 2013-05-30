CodeSync.StylesheetPackages = CodeSync.LocalStore.extend
  namespace: "stylesheet:package"

  initialize: (models=[], @options={})->
    models = CodeSync.StylesheetPackages.samples if _(models).isEmpty()
    CodeSync.LocalStore::initialize.call(@, models, @options)

  # Create a stylesheet package by passing a name and a list in a block
  # of text listing each stylesheet individually on one line.
  create: (attributes={}, options={})->
    {text,name,list} = attributes

    list ||= []

    for line in text.split("\n")
      list.push _.str.strip(line)

    model = new @model({list,name})

    @add(model, options)

    model

  model: Backbone.Model.extend
    initialize:(@attributes)->
      Backbone.Model::initialize.apply(@, arguments)

      status = {}

      for item in @attributes.list
        status[item] = false

      @set "status", status, silent: true

      pkg = @

      @updateStatus = _.debounce ()=>
        @onLoad.apply(pkg, arguments)
      , 400

    onLoad: (url)->
      status = @get("status")
      status[url] = true

      console.log "On Load", url, status

      @set({status})

    request: (root)->
      name = @get("name")

      root ||= window

      for script, value of @get("status")
        root.CodeSync.util.loadStylesheet script, tracker: "#{ name }:#{ script }", complete: @updateStatus

CodeSync.StylesheetPackages.samples =
  name: "bootstrap / amelia"
  list:[
    "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css"
    "//netdna.bootstrapcdn.com/bootswatch/2.3.1/amelia/bootstrap.min.css"
    "//netdna.bootstrapcdn.com/font-awesome/3.1.1/css/font-awesome.min.css"
  ]