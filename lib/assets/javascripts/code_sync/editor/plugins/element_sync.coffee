CodeSync.plugins.ElementSync = Backbone.View.extend
  buttonLabel: "Sync w/ element"

  buttonClass: "toggle-element-sync"

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

    @hide()
    @toggleButton(@visible)


    @bindToSelector = _.debounce ()=>
      @selector        = @getValue()
      @$elementSync    = (@searchScope || window).$(@selector)
      @status()
    , 500

    @editor.on "code:sync:template", @syncWithElement, @

    @editor.on "change:mode", (mode)=>
      if mode.isTemplate()
        @toggleButton(true)
      else
        @hide()
        @toggleButton(false)

    @editor.on "document:loaded", (doc)=>
      if doc.toMode().isTemplate()
        @toggleButton(true)

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

  renderButton: ()->
    $(@attachButtonTo).append("<div class='toggle-element-sync #{ @buttonClass }'>#{ @buttonLabel }</div>")

  render: ()->
    @renderButton()
    @$el.html JST["code_sync/editor/templates/element_sync"]()
    @status()
    @

  show: ()->
    @visible = true
    @$el.show()

  hide: ()->
    @visible = false
    @$el.hide()

  toggle:()->
    if @visible then @hide() else @show()

  toggleButton: (show=true)->
    if show
      @editor.$('.toggle-element-sync').show()
    else
      @editor.$('.toggle-element-sync').hide()


CodeSync.plugins.ElementSync.setup = (editor, options)->
  options.editor        = editor
  options.attachButtonTo ||= @$('.toolbar-wrapper')

  if editor.elementSyncScope
    options.searchScope = $(editor.elementSyncScope)

  view = new CodeSync.plugins.ElementSync(options)

  $ ->
    if editor.syncWithElement
      view.setValue(editor.syncWithElement)
      view.bindToSelector()

  editor.views.elementSync = view

  @events["click .toggle-element-sync"] = ()=>
    view.toggle()

  @$el.append view.render().el


