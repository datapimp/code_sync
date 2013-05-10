CodeSync.PreferencesPanel = Backbone.View.extend
  className: "preferences-panel"

  events:
    "change :input" : "updateEditor"

  initialize: (options)->
    @editor = options.editor
    _.bindAll(@, "updateEditor")
    @$el.html markup

    @$("input[name='asset-url']").val(@editor.assetCompilationEndpoint)

    Backbone.View::initialize.apply(@, arguments)

  updateEditor: ()->
    for setting, value of @values() when setting isnt "asset-url"
      @editor.codeMirror.setOption(setting, value)

    @editor.assetCompilationEndpoint = @values()["asset-url"]

    @

  syncWithEditorOptions: ()->
    @$(":input[name='keyMap']").val @editor.codeMirror.getOption('keyMap')
    @$(":input[name='mode']").val @editor.codeMirror.getOption('mode')
    @$(":input[name='asset-url']").val @editor.assetCompilationEndpoint

  values: ()->
    values = {}

    for el in @$(':input')
      input = $(el)
      values[input.attr('name')] = input.val()

    values

  toggle: ()->
    @syncWithEditorOptions()
    @$el.toggle()

  render: ()->
    @$el.hide()
    @


markup = """
  <div class='mode-selector control-group'>
    <label>Mode</label>
    <div class='controls'>
      <select name="mode">
        <option value="coffeescript">Coffeescript</option>
        <option value="haml">Haml</option>
        <option value="sass">Sass</option>
        <option value="scss">SCSS</option>
        <option value="skim">Skim</option>
        <option value="css">CSS</option>
        <option value="htmlmixed">HTML</option>
        <option value="ruby">Ruby</option>
      </select>
    </div>
  </div>
  <div class="keymap-selector control-group">
    <label>Keybindings</label>
    <select name="keyMap">
      <option value="default">Default</option>
      <option value="vim">Vim</option>
    </select>
  </div>
  <div class="theme-selector control-group">
    <label>Theme</label>
    <div class='controls'>
      <select name="theme">
        <option value="ambiance">Ambiance</option>
        <option value="lesser-dark">Lesser Dark</option>
        <option value="monokai">Monokai</option>
        <option value="xq-light">XQ Light</option>
      </select>
    </div>
  </div>
  <div class="asset-compilation-endpoint control-group">
    <label>Asset Compilation URL</label>
    <input type="text" name="asset-url" />
  </div>
"""
