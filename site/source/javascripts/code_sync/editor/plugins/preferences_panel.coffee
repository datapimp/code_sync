CodeSync.plugins.PreferencesPanel = CodeSync.EditorUtility.extend
  buttonIcon: "cog"

  tooltip: "Set preferences for this editor"

  className: "codesync-preferences-panel"

  panelTemplate: "preferences_panel"

  enableMode: true

  enableKeyBindings: true

  enableTheme: true

  enableEndpoint: false

  enableHotKey: false

  enablePosition: false

  events:
    "change select":  "updateEditor"
    "change input":   "updateEditor"

  getValues: ()->
    values = {}

    for field in @$('select,input')
      name = $(field).attr('name')
      values[name] = $(field).val()

    values

  syncWithEditor: ()->
    @$('select[name="theme"]').val @editor.codeMirror.getOption('theme')
    @$('select[name="mode"]').val (@editor.mode?.id || @editor.startMode)
    @$('select[name="keyMap"]').val @editor.codeMirror.getOption('keyMap')

  updateEditor: ()->
    values = @getValues()

    if @enableTheme and values.theme?
      @editor.setTheme(values.theme)

    if @enableKeyBindings and values.keyMap
      @editor.setKeyMap(values.keyMap)

    if @enableMode
      @editor.setMode( @modes.get(values.mode) )

  templateOptions: ->
    enableMode: @enableMode
    enableTheme: @enableTheme
    enableKeyBindings: @enableKeyBindings
    enableEndpoint: @enableEndpoint
    enableHotKey: @enableHotKey
    enablePosition: @enablePosition

  afterRender: ()->
    if @enableMode
      @modes = @editor.modes

      select = @$('.mode-selector select')

      options = ''
      for mode in @modes.models when mode.isOfType(@showModes) is true
        options += "<option value='#{ mode.id }'>#{ mode.get('name') }</option>"

      select.empty().html(options)

      select.val(@editor.startMode)

    @syncWithEditor()
