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
    "click .set-default-preferences": "setDefaultPreferences"

    "keyup input" : _.debounce ((e)-> @setOption(e)), 850

  initialize: (@options={})->
    _.extend(@,@options)

    @embeddable.once "after:render", ()=>
      if defaults = localStorage.getItem('codesync-default-preferences')
        if _.isString(defaults)
          for name, value of JSON.parse(defaults)
            @["set#{ _.str.capitalize(name) }"](value)

    Backbone.View::initialize.apply(@, arguments)

  setDefaultPreferences: ()->
    localStorage.setItem 'codesync-default-preferences', JSON.stringify
      height: @embeddable.height
      width: @embeddable.width
      layout: @embeddable.layout
      position: @embeddable.position?.value
      keyMap: @embeddable.keyMap
      theme: @embeddable.theme

  setOption: (e)->
    target  = @$(e.target)
    value   = target.val()
    name    = target.attr 'name'

    @["set#{ _.str.capitalize(name) }"](value)

  setTheme: (option)->
    @embeddable.theme = option
    @embeddable.$el.attr('data-theme', option )
    @embeddable.each (editor)-> editor.editor.setTheme(option)

  setKeyMap: (option)->
    @embeddable.keyMap = option
    @embeddable.$el.attr('data-keymap', option )
    @embeddable.each (editor)-> editor.editor.setKeyMap(option)

  # This is a hack until I can get the CSS
  # figured out.  How to make the editor panel
  # and codemirror elements automatically grow vertically.
  setHeight: (height)->
    @embeddable.height = height
    @embeddable.$el.css('height', height)
    @embeddable.redraw()

  setWidth:(width)->
    @embeddable.width = width
    @embeddable.$el.css('width', width)
    @embeddable.redraw()

  setLayout: (option)->
    @embeddable.layout = option
    @embeddable.$el.attr('data-layout', option)

  setPosition:(option)->
    @embeddable.$el.attr('data-position', option)
    @embeddable.position.value = option
    @embeddable.position.set(option)

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
    @$('.layout-selector').val( @embeddable.$el.attr('data-layout') )
    @$('.theme-selector').val( @embeddable.$el.attr('data-theme') )
    @$('.position-selector').val( @embeddable.$el.attr('data-position') )
    @$('.keymap-selector').val( @embeddable.$el.attr('data-keymap') )

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

