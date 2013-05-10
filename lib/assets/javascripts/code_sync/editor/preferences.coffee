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

  values: ()->
    values = {}

    for el in @$(':input')
      input = $(el)
      values[input.attr('name')] = input.val()

    values

  toggle: ()->
    @$el.toggle()

  render: ()->
    @$el.hide()
    @


markup = """
  <h5>Editor Settings</h5>
  <div class='mode-selector control-group'>
    <label>Mode</label>
    <div class='controls'>
      <select name="mode">
        <option value="coffeescript">Coffeescript</option>
        <option value="haml">Haml</option>
        <option value="sass">Sass</option>
        <option value="scss">SCSS</option>
        <option value="css">CSS</option>
        <option value="htmlmixed">HTML</option>
        <option value="ruby">Ruby</option>
      </select>
    </div>
  </div>
  <div class="keymap-selector contorl-group">
    <label>Keybindings</label>
    <select name="keyMap">
      <option value="default">Default</option>
      <option value="vim">Vim</option>
    </select>
  </div>
  <h5>Asset Compilation Endpoint</h5>
  <div class="asset-compilation-endpoint control-group">
    <label>URL</label>
    <input type="text" name="asset-url" />
  </div>
"""
