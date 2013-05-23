#= require_tree ./templates
#= require_self

CodeSync.PryConsole = Backbone.View.extend
  className: "codesync-pry-console"

  endpoint: "http://localhost:9295/pry-console"

  rendered: false

  events:
    "keydown input" : "processInput"
    "submit form" : (e)->
      e.preventDefault()

  initialize: (@options={})->
    _.extend(@, @options)
    Backbone.View::initialize.apply(@,arguments)

  processInput: (e)->
    if e.keyCode is 13 and @getCode().length > 0
      @sendCode(true)


  sendCode: ()->
    $.ajax
      url: @endpoint

      type: "POST"

      success: (response)=>
        console.log("Success", response)

      error: (response)=>
        console.log("Error", response)

      data:
        code: @getCode()


  getCode: ()->
    @$('input#code').val()

  render: ()->
    @$el.html JST["code_sync/console/templates/console"](endpoint: @endpoint)
    @rendered = true
    @

CodeSync.PryConsole.renderSingleton = (renderToElement)->
  renderToElement ||= $('body')

  window.codeSyncConsole?.remove()
  window.codeSyncConsole = new CodeSync.PryConsole()
  $(renderToElement).html(codeSyncConsole.render().el)
