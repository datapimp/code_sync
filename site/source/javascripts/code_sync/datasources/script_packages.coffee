CodeSync.ScriptPackages = CodeSync.LocalStore.extend
  namespace: "script:package"

  initialize: (models=[], @options={})->
    models = CodeSync.ScriptPackages.samples if _(models).isEmpty()
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
        console.log "Script Loaded", url
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
        console.log "Loading Script", script
        root.CodeSync.util.loadScript script, tracker: "#{ name }:#{ script }", complete: @updateStatus

s = CodeSync.ScriptPackages.samples = []

s.push
  name: "Backbone + Underscore + jQuery"
  list:[
    "//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.1/jquery.min.js"
    "//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"
    "//cdnjs.cloudflare.com/ajax/libs/underscore.string/2.3.0/underscore.string.min.js"
    "//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min.js"
  ]
