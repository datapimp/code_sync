CodeSync.plugins.AssetSelector = CodeSync.ToolbarPanel.extend
  className: "codesync-asset-selector"

  panelTemplate: "asset_selector"

  buttonIcon: "search"

  entranceEffect: "fadeIn"

  exitEffect: "fadeOut"

  tooltip: "Load a document from this project"

  handle: "assetSelector"

  events:
    "keyup input": "keyHandler"
    "click .search-result": "selectSearchResult"

  initialize:(options={})->
    CodeSync.ToolbarPanel::initialize.apply(@, arguments)

    _.bindAll(@,"keyHandler","loadAssetByPath","loadDocument")

    @selected = new Backbone.Model(index: -1)

    @selected.on "change:index", (model,value)=>
      @$('.search-result').removeClass('active')
      @$('.search-result').eq(value).addClass('active')

  keyHandler: (e)->
    switch e.keyCode
      when 13
        @openCurrentSearchResult()
      when 27
        @hide()
      when 38
        @previousSearchResult()
      when 40
        @nextSearchResult()
      else
        @filterAssetsBy @$('input').val()

  openCurrentSearchResult: ()->
    {index} = @selected.attributes

    if asset = @searchResults[index]
      @selected.set('index',0,silent:true)

      _.delay ()=>
        @loadDocument @searchResults[index]
        @hideSearchResults()
      , 10

      @hide()

  previousSearchResult: ()->
    {index} = @selected.attributes
    index -= 1
    index = 0 if index < 0
    @selected.set {index}

  nextSearchResult: ()->
    {index} = @selected.attributes
    index += 1
    index = 0 if index > @searchResults.length
    @selected.set {index}

  selectSearchResult: (e)->
    target = @$(e.target).closest('.search-result')
    @selected.set target.data('index')
    @openCurrentSearchResult()

  loadAssetByPath: (path)->
    @trigger "asset:selected", path
    @editor.documentManager?.openDocuments?.findOrCreateForPath path, (doc)=>
      @editor.documentManager.openDocument(doc,@editor)

  loadDocument: (doc)->
    doc.loadSourceFromDisk (doc)=>
      @editor.documentManager?.openDocument(doc, @editor)

  filterAssetsBy: (value)->
    return if value.length <= 1

    wrapper = @showSearchResults()
    wrapper.empty()

    @selected.set('index',-1, silent: true)

    @searchResults = @collection.select (doc)->
      regex = new RegExp("#{value}")
      doc.nameWithExtension()?.match(regex) || doc.get("description")?.match(regex) || doc.get("path")?.match(regex)

    @searchResults = @searchResults.slice(0,5)

    for model,index in @searchResults
      wrapper.append "<div data-path='#{ model.get('path') }' class='search-result'>#{ model.description() }</div>"

    wrapper.height( @searchResults.length * 40 )

  render: ()->
    return @ if @rendered

    @collection = CodeSync.Documents.getProjectAssets()

    CodeSync.ToolbarPanel::render.apply(@, arguments)
    @wrapper = @$(".search-results-wrapper")
    @

  show: ()->
    CodeSync.ToolbarPanel::show.apply(@, arguments)
    @selected.set "index", undefined
    @$('input').val()


  showSearchResults: ()->
    @wrapper.show()

  hideSearchResults: ()->
    @wrapper.hide()

