CodeSync.plugins.StylesheetLoader = CodeSync.ToolbarPanel.extend
  buttonIcon: "cloud"
  className: "stylesheet-loader"
  tooltip: "Load external stylesheets"
  panelTemplate: "stylesheet_loader"
  availableInModes:"stylesheet"
  handle: "stylesheetLoader"

  templateOptions: ()->
    packages: @packages

  initialize:(@options={})->
    @packages = new CodeSync.StylesheetPackages()

    @packages.fetch success: ()=> @packages.add(CodeSync.StylesheetPackages.samples) if @packages.length is 0


    CodeSync.ToolbarPanel::initialize.apply(@, arguments)

  events:
    "click .submit" : "loadResources"
    "change select" : "loadPackage"

  loadPackage: (e)->
    target        = @$(e.target).closest('select')
    package_name  = target.val()

    model = @packages.detect (model)-> model.get("name") is package_name

    if model?
      @$('textarea').val model.get('list').join("\n")

  showRequestStatus: (pkg)->
    container = @$('.results-container').empty()

    for script, status of pkg.get('status')
      container.append "<li>#{ script }</li>"

  loadResources: ()->
    name = @$('select').val()
    list = @$('textarea').val()

    if @package?
      @package.off "change"

    @package = @packages.create(name:name,text:list)

    @package.on "change", @showRequestStatus, @

    @$('.card').removeClass('active')
    @$('.card.results').addClass('active')

    @package.request(@editor.targetWindow)