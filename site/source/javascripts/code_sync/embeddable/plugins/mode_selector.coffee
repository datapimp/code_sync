# Allows a user to select from a list of modes to change
# the editor language
CodeSync.plugins.LanguageSelector = Backbone.View.extend
  visible: false

  entranceEffect: "fadeIn"
  exitEffect: "fadeOut"

  className: "embeddable-utility-panel top-aligned embeddable-mode-selector"

  events:
    "change select": "setOption"
    "click .cancel": "hide"

  initialize: (@options={})->
    _.extend(@,@options)

    Backbone.View::initialize.apply(@, arguments)

    @modes  = @editor.modes

  restrictedModes: ()->
    editorMode      = @editor.startMode || "any"
    console.log "Restricting to", editorMode.type()
    @modes.select (mode)->
      mode.isOfType editorMode.type()

  setOption: (e)->
    target  = @$(e.target)
    value   = target.val()
    name    = target.attr 'name'

    @["set#{ _.str.capitalize(name) }"](value)

  show: ()->
    @visible = true
    @render()
    @setValues()
    @$el.removeClass(@exitEffect).addClass("animated #{ @entranceEffect }")
    @

  hide: ()->
    @visible = false
    @$el.removeClass(@entranceEffect).addClass("animated #{ @exitEffect }")
    @

  toggle: ()->
    if @visible then @hide() else @show()
    @

  setValues: ()->

  render: ()->
    return @ if @rendered

    @$el.html CodeSync.template("embeddable-mode-selector", @)
    @editor.parent.$el.append(@el)

    @rendered = true
    @


CodeSync.plugins.LanguageSelector.setup = (editor,options={})->
  editor.languageSelector  = new CodeSync.plugins.LanguageSelector(editor: @)
