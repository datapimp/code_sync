#= require ./dependencies
#= require_self

class CodeSync.AssetEditor

  @instances: {}

  @getInstance: (options={})->
    @instances.main ||= new CodeSync.AssetEditor(options)

  visible: false

  constructor: (@options={})->
    el = @editorElement()


    CodeMirror el[0],
      height: 500
      width: 500
      mode: 'coffeescript'
      theme: 'lesser-dark'
      value: ''
      lineNumbers: true
      autofocus: true

  editorElement: ()->
    el = $('#codesync-editor-element')

    return el if el.length isnt 0

    $('body').append "<div id='codesync-editor-wrapper'><div id='codesync-editor-element'></div></div>"

    el = $('#codesync-editor-element')

  toggle: ()->
    if @visible then @hide() else @show()

  show: ()->
    $('#codesync-editor-wrapper').show()
    @visible = true
    @

  hide: ()->
    $('#codesync-editor-wrapper').hide()
    @visible = false
    @
