CodeSync.plugins.ElementSync = Backbone.View.extend
  buttonLabel: ""

  buttonClass: "icon icon-loop"

  className : "codesync-element-sync toggleable-input"

  action: "html"

  visible: true

  events:
    "keyup input" : ()->
      @bindToSelector()

    "change select": (e)->
      @action = @$(e.target).val()

    "click .hide-panel-button" : ()->
      @hide()

    "click .done-button" : ()->
      @clear()

  initialize: (@options={})->
    _.extend(@,@options)

    @bindToSelector = _.debounce ()=>
      @selector        = @getValue()
      @$elementSync    = (@searchScope || window).$(@selector)
      @status()
    , 500

    @editor.on "code:sync:template", @syncWithElement, @

    @editor.on "change:mode", (mode)=>

    @editor.on "document:loaded", (doc)=>

  syncWithElement: (doc)->
    return unless @selector and tmpl = doc.templateFunction()
    @$elementSync?[@action || "html"](tmpl())

  getSelectorContents: ()->
    @$elementSync.html()

  getValue: ()->
    @$('input[name="css-selector"]').val()

  setValue: (@selector)->
    @$('input[name="css-selector"]').val(@selector)
    @bindToSelector()

  clear: ()->
    @$('input[name="css-selector"]').val('')
    @$elementSync = undefined
    @selector = ''
    @$('.element-sync-status').html("")

  existsInDocument: ()->
    @$elementSync?.length > 0

  status: ()->
    length = @$elementSync?.length

    msg = if length is 0 && @getValue().length > 0
      "CSS Selector not found"
    else if length is 1
      "1 total element"
    else if length > 0
      "#{ length } total elements"
    else
      ""

    @$('.element-sync-status').html(msg)
