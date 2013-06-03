CodeSync.EmbeddableView = Backbone.View.extend

  className:  "codesync-embeddable"

  template:   "codesync-embeddable"

  defaultEditorConfig:
    template: {}
    style: {}
    script: {}

  initialize:(@options={})->
    _.extend(@,@options)

    @toolbarItems     = @defaultToolbarItems || {}
    @editorConfig     = @defaultEditorConfig || {}
    @documentManager  = new CodeSync.DocumentManager()

  addEditorPanel: (editor)->
    @panelCount ||= 0
    @editorPanelWrapper ||= @$('.panels-wrapper')

    panel = new CodeSync.EditorPanel(editor)
    panel.parent = @

    panel.$el.attr("data-panel", @panelCount++)

    panel.renderIn(@editorPanelWrapper)

    panel

  addToolbarItem: (item, options={})->
    {position} = options

    itemElement   = $(CodeSync.template(item.template || "embeddable-toolbar-item", item))
    container     = @$(">.toolbar.#{ position }").removeClass('empty')

    if item.section?
      container = container.find('.' + item.section).removeClass('empty, fpo')

    container.append(itemElement)

    if item.action
      itemElement.on "click", (e)=>
        @handleToolbarClick.call(@, item.action, item, e)

  handleToolbarClick: (action, toolbarItemConfig, e)->

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

  renderToolbars: ()->
    for position, items of @toolbarItems
      @addToolbarItem(item, {position}) for item in items

  render: ()->
    @$el.html(CodeSync.template(@template))
    @renderToolbars()
    @

  renderIn: (container)->
    container.empty().append( @render().el ).attr('data-embeddable-instance', @cid)

    @renderEditors()

    _(@panels).each (panel)->
      panel.setupCodeMirror()
      _.delay ()->
        value = panel.editor.currentDocument.toContent()
        panel.editor.codeMirror.setValue(value)
      , 5

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
