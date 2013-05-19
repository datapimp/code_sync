CodeSync.plugins.ColorPicker = Backbone.View.extend
  className: "codesync-color-picker"

  widget: false

  spectrumOptions:
    showAlpha: false
    preferredFormat: "hex6"
    flat: true
    showInput: true
    chooseText: "Choose"


  initialize: (@options={})->
    _.extend(@,@options)

    @$el.append "<input type='color' class='color-picker-widget' />"

    @widget = @$('.color-picker-widget')

  remove: ()->
    @widget.spectrum("destroy")
    @$el.remove()

  hide: ()->
    @widget.spectrum("hide")
    @$el.hide()

    @off "color:change"

  show: ()->
    @widget.spectrum("show")
    @$el.addClass('anchored') unless @widget
    @$el.show()

  syncWithToken: (token, cursor)->

    cm = @editor.codeMirror

    if @widget is true
      @$el.removeClass('anchored')
      cm.addWidget(cursor, @el)

    @show()

    line = cm.getLine(cursor.line)

    startch = token.start
    endch = token.end

    @widget.spectrum("set",token.string)

    @on "color:change", _.debounce (colorObject, hexValue)=>
      cm.replaceRange("#"+hexValue, {line:cursor.line,ch:startch}, {line:cursor.line,ch:endch})
      @editor.currentDocument?.trigger("change:contents")

  render: ()->
    opts = _.extend @spectrumOptions,
      move: _.debounce((color)=>
        @trigger "color:change", color, color.toHex()
      ,200)

    @widget.spectrum(@spectrumOptions)

    @

CodeSync.plugins.ColorPicker.setup = (editor)->
  @colorPicker = new CodeSync.plugins.ColorPicker(editor: editor)

  @$el.append( editor.colorPicker.render().el )
  @colorPicker.hide()

  cm = editor.codeMirror

  cm.on "cursorActivity", ->
    cursor = cm.getCursor()
    token = cm.getTokenAt(cursor)

    if token.string?.match(/#[a-fA-F0-9]{3,6}/g) and token.string?.length >= 6
      editor.colorPicker.syncWithToken(token, cursor)
    else
      editor.colorPicker.hide()
