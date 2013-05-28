CodeSync.plugins.PreferencesPanel = CodeSync.ToolbarPanel.extend
  buttonIcon: "cog"

  tooltip: "Set preferences for this editor"

  className: "preferences-panel"

  panelTemplate: "preferences_panel"

  enableMode: true

  enableKeyBindings: true

  enableTheme: true

  enableEndpoint: false

  enableHotKey: false

  enablePosition: false

  events:
    "change select" : "updateEditor"
    "change input" : "updateEditor"

  updateEditor: ()->

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

