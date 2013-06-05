CodeSync.Modes = Backbone.Collection.extend
  model: Backbone.Model.extend
    type: ()->
      return "template" if @get("template") is true
      return "style" if @get("style") is true
      return "script" if @get("script") is true

    isOfType: (type="any")->
      @get(type) is true || type is "any" || type is "all"

    isTemplate: ()->
      @get("template") is true

    isStylesheet: ()->
      @get("style") is true

    isScript: ()->
      @get("script") is true

    isBackend: ()->
      @get("backend") is true


  initialize: (models=[], options={})->
    models = for key, value of modes
      attributes = _.extend value,
        id: key
        name: value.name || key
        codeMirrorMode: value.codeMirrorMode || key
        extensionRegex: new RegExp("#{ value.extension }")
        template: (value.template is true || key is "skim" || value.extension?.match(/jst/))

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
    script: true

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
    style: true

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
    style: true

  haml:
    codeMirrorMode: "haml"
    extension: ".hamlc"
    name: "Haml Coffee"
    template: true
    defaultContent: "/ HAML Coffeescript Mode "

  skim:
    extension: ".jst.skim"
    defaultContent: "// You are currently in Skim mode.\n// The contents of this template will be available on the JST object."
    template: true
    codeMirrorOptions:
      indentUnit: 2
      smartIndent: true
      tabSize: 2
      indentWithTabs: false

  html:
    name: "HTML"
    codemirrorMode: "html"
    extension: ".html"
    defaultContent: "<!-- HTML Mode -->"
    template: true
    raw: true

  css:
    name: "CSS"
    extension: ".css"
    codeMirrorMode: "css"
    defaultContent: "/* You are currently in raw CSS mode. */"
    style: true
    raw: true

  javascript:
    name: "Javascript"
    extension: ".js"
    codeMirrorMode: "javascript"
    defaultContent: "/* You are currently in raw JS mode. */"
    script: true
    raw: true





