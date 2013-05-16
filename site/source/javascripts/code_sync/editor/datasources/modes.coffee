CodeSync.Modes = Backbone.Collection.extend
  initialize: (models=[], options={})->
    models = for key, value of modes
      attributes =
        id: key
        name: value.name || key
        codeMirrorMode: value.codeMirrorMode || key
        extension: value.extension
        extensionRegex: new RegExp("#{ value.extension }")
        defaultContent: value.defaultContent

    Backbone.Collection::initialize.apply(@, arguments)

    @reset(models, silent: true)

  findModeFor: (pathOrFilename="")->
    pathOrFilename = ".#{ pathOrFilename }" unless pathOrFilename.match(/\./)

    mode = @detect (model)=>
      regex = model.get("extensionRegex")
      regex.exec(pathOrFilename)

    mode?.get("codeMirrorMode")

  findExtensionFor: (mode)->
    mode = @detect (model)->
      model.get('codeMirrorMode') is mode || model.get('id') is mode

    mode?.get("extension")

  defaultMode: ()->
    @get(CodeSync.get("defaultFileType")) || @first()

CodeSync.Modes.getMode = (id)->
  CodeSync.Modes.get().get(id)

CodeSync.Modes.guessModeFor = (pathOrFilename)->
  CodeSync.Modes.get().findModeFor(pathOrFilename)

CodeSync.Modes.guessExtensionFor = (mode)->
  CodeSync.Modes.get().findExtensionFor(mode)

CodeSync.Modes.get = ()->
  CodeSync.Modes.singleton ||= new CodeSync.Modes()

CodeSync.Modes.defaultMode = ()->
  CodeSync.Modes.get().defaultMode()

modes =
  coffeescript:
    extension: ".coffee"
    defaultContent: "# You are currently in coffeescript mode."

  sass:
    name: "Sass"
    extension: ".css.sass"
    defaultContent: "// You are currently in Sass mode."

  scss:
    codeMirrorMode: "css"
    extension: ".css.scss"
    name: "SCSS"
    defaultContent: "/* You are currently in SCSS mode. */"

  skim:
    extension: ".jst.skim"
    defaultContent: "// You are currently in Skim mode.\n// The contents of this template will be available on the JST object."
    template: true

  css:
    name: "CSS"
    extension: ".css"
    defaultContent: "/* You are currently in raw CSS mode. */"

  javascript:
    name: "Javascript"
    extension: ".js"
    defaultContent: "/* You are currently in raw JS mode. */"



