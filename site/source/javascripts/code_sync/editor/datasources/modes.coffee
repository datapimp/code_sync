CodeSync.Modes = Backbone.Collection.extend
  initialize: (models=[], options={})->
    models = for key, value of modes
      attributes =
        id: key
        name: value.name || key
        codeMirrorMode: value.codeMirrorMode || key
        extension: value.extension
        extensionRegex: new RegExp("#{ value.extension }")

    Backbone.Collection::initialize.apply(@, arguments)

    @reset(models, silent: true)

  findModeFor: (pathOrFilename)->
    mode = @detect (model)=>
      regex = model.get("extensionRegex")
      regex.exec(pathOrFilename)

    mode?.get("codeMirrorMode")

  findExtensionFor: (mode)->
    mode = @detect (model)->
      model.get('codeMirrorMode') is mode || model.get('id') is mode

    mode?.get("extension")

  defaultMode: ()->
    defaultFileType = CodeSync.get("defaultFileType")
    @get(defaultFileType)?.get("codeMirrorMode")


CodeSync.Modes.guessModeFor = (pathOrFilename)->
  CodeSync.Modes.get().findModeFor(pathOrFilename)

CodeSync.Modes.guessExtensionFor = (mode)->
  CodeSync.Modes.get().findExtensionFor(mode)

CodeSync.Modes.get = ()->
  CodeSync.Modes.singleton ||= new CodeSync.Modes()

modes =
  coffeescript:
    extension: ".coffee"

  sass:
    name: "Sass"
    extension: ".css.sass"

  scss:
    codeMirrorMode: "css"
    extension: ".css.scss"

  skim:
    extension: ".jst.skim"

  css:
    name: "CSS"
    extension: ".css"

  javascript:
    name: "Javascript"
    extension: ".js"



