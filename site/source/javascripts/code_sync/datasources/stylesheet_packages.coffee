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

    model = new @model(list: list, name: name)

    @add(model, options)

    model


  model: Backbone.Model.extend

    sync: CodeSync.LocalStore::sync

    initialize:(@attributes)->
      Backbone.Model::initialize.apply(@, arguments)

      status = {}

      for item in @attributes.list
        status[item] = false

      @set "status", status, silent: true

      pkg = @

      @updateStatus = (url)=>
        @onLoad.apply(pkg, arguments)
        @attributes.status[url] = true
        @trigger "resource:loaded", pkg, url

    onLoad: (url)->
      status = @get("status")
      status[url] = true

      @set({status})

    request: (root)->
      name = @get("name")

      root ||= window

      for script, value of @get("status")
        root.CodeSync.util.loadStylesheet script, tracker: "#{ name }:#{ script }", complete: @updateStatus

s = CodeSync.StylesheetPackages.samples = []

s.push
  name: "purecss.io"
  list:[
    "//yui.yahooapis.com/pure/0.1.0/pure-min.css"
  ]

s.push
  name: "Luca"
  list:[
    "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.0/css/bootstrap-combined.min.css"
    "//netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome.css"
    "//datapimp.github.com/luca/vendor/assets/stylesheets/luca-ui.css"
  ]

s.push
  name: "bootstrap / amelia"
  list:[
    "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css"
    "//netdna.bootstrapcdn.com/bootswatch/2.3.1/amelia/bootstrap.min.css"
    "//netdna.bootstrapcdn.com/font-awesome/3.1.1/css/font-awesome.min.css"
  ]
