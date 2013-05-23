CodeSync.plugins.ElementSync = Backbone.View.extend

  className : "codesync-element-sync toggleable-input"

  action: "html"

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
      @$elementSync    = $(@selector)
      @status()
    , 500


    @editor.on "code:sync:template", @syncWithElement, @

    @editor.on "change:mode", (mode)=>
      if mode.isTemplate()
        @toggleButton(true)
      else
        @hide()
        @toggleButton(false)

    @visible = false
    @$el.hide()
    @toggleButton(false)

  syncWithElement: (doc, templateFn)->
    @selector && @$elementSync?[@action || "html"]?(templateFn())

  getSelectorContents: ()->
    @$(@selector).html()

  getValue: ()->
    @$('input[name="css-selector"]').val()

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

  render: ()->
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


CodeSync.plugins.ElementSync.setup = (editor)->
  @$('.toolbar-wrapper').append "<div class='button toggle-element-sync'>Sync w/ Element</div>"

  view = new CodeSync.plugins.ElementSync({editor})

  editor.views.elementSync = view

  @events["click .toggle-element-sync"] = ()=>
    view.toggle()

  @$el.append view.render().el


