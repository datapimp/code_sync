CodeSync.plugins.PreferencesPanel = Backbone.View.extend
  className: "preferences-panel"

  events:
    "change select,input" : ()->
      @trigger "update:preferences"

  renderHidden: true

  initialize: (options)->
    @editor = options.editor

    @$el.html JST["code_sync/editor/templates/preferences_panel"]()

    Backbone.View::initialize.apply(@, arguments)

  values: ()->
    values = {}

    for el in @$('input,select')
      input = $(el)
      values[input.attr('name')] = input.val()

    values

  toggle: ()->
    @syncWithEditorOptions()
    @$el.toggle()

  syncWithEditorOptions: ()->
    @$('select[name="theme"]').val @editor.codeMirror.getOption('theme')
    @$('select[name="keyMap"]').val @editor.codeMirror.getOption('keyMap')
    @$('input[name="asset_endpoint"]').val CodeSync.get("assetCompilationEndpoint")
    @$('input[name="editor_hotkey"]').val CodeSync.get("editorToggleHotKey")

  render: ()->
    @$el.hide() if @renderHidden is true
    @


CodeSync.plugins.PreferencesPanel.setup = (editor)->
  panel = new CodeSync.plugins.PreferencesPanel(editor: @)

  @$('.toolbar-wrapper').append "<div class='button toggle-preferences'>Preferences</div>"

  @events["click .toggle-preferences"] = ()=> panel.toggle()

  @$el.append panel.render().el

  panel.on "update:preferences", ()=>
    values = panel.values()

    editor.setTheme(values.theme)
    editor.setKeyMap(values.keyMap)

    CodeSync.set("assetCompilationEndpoint", values.asset_endpoint)

    CodeSync.AssetEditor.setHotKey(values.editor_hotkey)

  editor.on "codemirror:setup", (cm)->
    cm.on "focus", ()->
      panel.$el.hide()

  panel.on "update:preferences", ()=>
    values = panel.values()
    if editor.position isnt values.position
      editor.setPosition(values.position)




