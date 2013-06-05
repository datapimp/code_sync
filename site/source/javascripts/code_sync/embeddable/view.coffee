resize =
  icon:     "resize-editor"
  tooltip:  "Resize this editor"
  action:   "resize"
  section:  "right"

mode =
  icon: "comment"
  tooltop: "Select the language"
  action: "selectMode"
  section: "right"

move =
  icon: "fullscreen"
  tooltip: "Re-arrange this panel"
  action: "rearrange"
  section: "left"
  eventListener: "mousedown"


CodeSync.EmbeddableView = Backbone.View.extend

  className:  "codesync-embeddable"

  template:   "codesync-embeddable"

  defaultEditorConfig:
    template:
      startMode: "skim"
      toolbarItems:
        top:[
          move,
          mode,
          resize
        ]

    style:
      startMode: "scss"
      toolbarItems:
        top:[
          move,
          mode,
          resize
        ]

    script:
      startMode: "cofeescript"
      toolbarItems:
        top:[
          move,
          mode,
          resize
        ]


  plugins:[
    "Draggable"
    "Resizable"
    "EmbeddablePreferences"
  ]

  events:
    "click .toggle-preferences" : ()->
      @preferencesPanel.toggle()

  initialize:(@options={})->
    _.extend(@,@options)

    @toolbarItems     = @defaultToolbarItems || {}
    @editorConfig     = @defaultEditorConfig || {}
    @documentManager  = new CodeSync.DocumentManager()

    for plugin in @plugins when CodeSync.plugins[plugin]?
      CodeSync.plugins[plugin].setup?.call(@, @, @pluginOptions?[plugin])

  addEditorPanel: (editor)->
    @panelCount ||= 0
    @editorPanelWrapper ||= @$('.panels-wrapper')

    panel = new CodeSync.EditorPanel(editor)
    panel.parent = @

    panel.$el.attr("data-panel", @panelCount++)

    panel.renderIn(@editorPanelWrapper)

    panel

  setLayout: (@layout)->
    @$el.attr('data-layout', @layout)
    @trigger "layout:change"

  renderEditors: ()->
    @editors ||= {}

    @panels = for name, editor of @editorConfig
      @addEditorPanel(_.defaults(editor,{name}))

    for panel, index in @panels
      settings =
        'width': "#{ (1/@panels.length) * 100 }%"
        'left':"#{ (1/@panels.length) * 100 * index }%"

      panel.setOriginalPosition(settings)

    @setLayout("#{ @panels.length }")

  each: (args...)->
    _(@panels).each(args...)

  render: ()->
    @$el.html(CodeSync.template(@template))
    @

  renderIn: (container, options={})->
    container.append( @render().el ).attr('data-embeddable-instance', @cid)

    @renderEditors()

    _(@panels).each (panel)->
      panel.setupCodeMirror()
      _.delay ()->
        value = panel.editor.currentDocument.toContent()
        panel.editor.codeMirror.setValue(value)
      , 5

    @trigger "ready"

    @

  resizeDelay: 600

  resizePanel: (panel)->
    @$el.addClass 'animating'

    el = panel.$el
    index = el.index()

    if panel.expanded is true

      el.addClass 'animating'

      el.animate panel.originalPosition, complete: ()=>
        _.delay ()=>
          el.removeClass 'expanded'
          @$el.removeClass 'animating'
          el.removeClass 'animating'
          panel.expanded = false
        , @resizeDelay

    else
      fullSettings =
        width: "100%"
        left: "0%"
        right: "0%"

      el.addClass 'animating'

      _.delay ()=>
        el.animate fullSettings, complete: ()=>
          panel.expanded = true
          el.addClass('expanded')
          @$el.removeClass 'animating'
          el.removeClass('animating')
      , @resizeDelay
