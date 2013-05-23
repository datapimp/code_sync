CodeSync.Modes = Backbone.Collection.extend
  model: Backbone.Model.extend
    isTemplate: ()->
      @get("template") is true

  initialize: (models=[], options={})->
    models = for key, value of modes
      attributes =
        id: key
        name: value.name || key
        codeMirrorMode: value.codeMirrorMode || key
        extension: value.extension
        extensionRegex: new RegExp("#{ value.extension }")
        template: (value.template is true || key is "skim" || value.extension?.match(/jst/))
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
    codeMirrorOptions:
      indentUnit: 2
      smartIndent: true
      tabSize: 2
      indentWithTabs: false

    defaultContent:  """
    # You are currently in Coffeescript Mode
    #
    # Any coffeescript you type in here will be evaluated.
    #
    # defining this function will allow you to respond
    # to code and template changes that happen in this editor.
    #
    #
    # CodeSync.onScriptChange = (changeObject)->
    #   console.log "Detected new code from CodeSync", changeObject
    #
    #
    """

  sass:
    name: "Sass"
    extension: ".css.sass"
    defaultContent: "// You are currently in Sass mode."

    codeMirrorOptions:
      indentUnit: 2
      smartIndent: true
      tabSize: 2
      indentWithTabs: false

  scss:
    codeMirrorMode: "css"
    extension: ".css.scss"
    name: "SCSS"
    defaultContent: "/* You are currently in SCSS mode. */"

  skim:
    extension: ".jst.skim"
    defaultContent: "// You are currently in Skim mode.\n// The contents of this template will be available on the JST object."
    template: true
    codeMirrorOptions:
      indentUnit: 2
      smartIndent: true
      tabSize: 2
      indentWithTabs: false

  css:
    name: "CSS"
    extension: ".css"
    defaultContent: "/* You are currently in raw CSS mode. */"

  javascript:
    name: "Javascript"
    extension: ".js"
    defaultContent: "/* You are currently in raw JS mode. */"



