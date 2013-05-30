CodeSync.plugins.ElementSync = CodeSync.ToolbarPanel.extend
  buttonIcon: "loop"

  tooltip: "Sync markup content with the DOM"

  className: "codesync-element-sync"

  action: "html"

  visible: false

  panelTemplate: "element_sync"

  availableInModes: "template"

  handle: "elementSync"

  events:
    "keyup input" : (e)->
      if $(e.target).val() is ""
        @selectedElement = undefined

      @bindToSelector()

    "change select": (e)->
      @action = @$(e.target).val()

    "click .hide-panel-button" : ()->
      @syncWithElement()
      @editor.currentDocument?.trigger("change:contents")
      @hide()

    "click .find-button" : ()->
      root = @searchScope || window

      el = root.$('body')

      el.on "inspekt", (e, selected)=>
        @selectElement $(selected.target)

      CodeSync.util.inspectElementsWithin({root,el})

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

    CodeSync.ToolbarPanel::initialize.apply(@, arguments)

  render: ()->
    CodeSync.ToolbarPanel::render.apply(@, arguments)

  selectElement: (@selectedElement, display)->
    id    = $(@selectedElement).attr('id')
    cls   = $(@selectedElement).attr('class')

    if !display? && $(@selectedElement).length > 0
      display   = $(@selectedElement)[0].tagName
      display   += "##{ id }" if id?
      display   += ".#{ cls }" if cls?

      @$('input[name="css-selector"]').val(display)

    @selector = @selectedElement

    @bindToSelector

  syncWithElement: (doc)->
    return unless @selector and tmpl = doc.templateFunction()
    @$elementSync?[@action || "html"](tmpl())

  getSelectorContents: ()->
    @$elementSync.html()

  getValue: ()->
    @selectedElement || @$('input[name="css-selector"]').val()

  setValue: (@selector)->
    @$('input[name="css-selector"]').val(@selector)
    @bindToSelector()

  clear: ()->
    @$('input[name="css-selector"]').val('')
    @selector = @selectedElement = @$elementSync = undefined
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

    if name = (@searchScope || window)?.name
      @$('.search-scope-description').html(name)

    @$('.element-sync-status').html(msg)
