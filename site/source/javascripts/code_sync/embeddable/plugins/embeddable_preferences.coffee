# Preferences Panel which controls the settings of all
# EditorComponent instances inside of an EmbeddableView

CodeSync.plugins.EmbeddablePreferences = Backbone.View.extend
  visible: false

  entranceEffect: "fadeIn"
  exitEffect: "fadeOut"

  className: "embeddable-utility-panel bottom-aligned embeddable-preferences"

  events:
    "change select": "setOption"
    "click .cancel": "hide"
    "keyup input" : _.debounce ((e)-> @setOption(e)), 850

  initialize: (@options)=>
    _.extend(@,@options)
    true
    Backbone.View::initialize.apply(@, arguments)

  setOption: (e)->
    target  = @$(e.target)
    value   = target.val()
    name    = target.attr 'name'

    @["set#{ _.str.capitalize(name) }"](value)

  setHeight: (option)->
    @embeddable.$el.css('height', option)

  setWidth:(option)->
    @embeddable.$el.css('width', option)

  setLayout: ()->
    @embeddable.$el.attr('data-layout', option)

  setPosition:(option)->
    @embeddable.$el.attr('data-position', option)

    if option is "top" || option is "bottom"
      # TODO
      true

    if option is "draggable"
      @embeddable.$el.draggable()

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
    @$("input[name='height']").val( @embeddable.$el.height() )
    @$("input[name='width']").val( @embeddable.$el.width() )

  render: ()->
    return @ if @rendered

    @embeddable.$el.append( @el )

    settings =
      theme: @embeddable?.theme
      keybindings: @embeddable?.keybindings

    @$el.html CodeSync.template("embeddable-preferences", settings)

    @rendered = true
    @


CodeSync.plugins.EmbeddablePreferences.setup = (embeddable,options={})->
  options.embeddable = @

  panel = new CodeSync.plugins.EmbeddablePreferences(options)
  panel.embeddable = @

  @preferencesPanel = panel

