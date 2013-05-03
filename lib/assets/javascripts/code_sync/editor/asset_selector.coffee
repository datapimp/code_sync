CodeSync.AssetSelector = Backbone.View.extend
  className: "codesync-asset-selector"

  events:
    "keyup input": "keyHandler"
    "click .search-result": "selectSearchResult"

  initialize:(options={})->
    Backbone.View::initialize.apply(@, arguments)

    @editor = options.editor

    _.bindAll(@,"keyHandler","loadAsset")

    @selected = new Backbone.Model(index: -1)

    @selected.on "change:index", (model,value)=>
      console.log "change", value
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
        @loadAsset @searchResults[index].get('path')
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
    loadAsset $(e.target)?.data('path')

  loadAsset: (path)->
    if path
      @editor.loadAsset(path)
      @hide()

  filterAssetsBy: (value)->
    return if value.length <= 1

    wrapper = @showSearchResults()
    wrapper.empty()

    @selected.set('index',-1, silent: true)

    @searchResults = @editor.assetsCollection.select (model)->
      regex = new RegExp("#{value}")
      model.get("description")?.match(regex) || model.get("path")?.match(regex)

    @searchResults = @searchResults.slice(0,5)

    for model,index in @searchResults
      wrapper.append "<div data-path='#{ model.get('path') }' class='search-result'>#{ model.get('description') }</div>"

    wrapper.height( @searchResults.length * 40 )

  showSearchResults: ()->
    @wrapper.show()

  hideSearchResults: ()->
    @wrapper.hide()

  toggle: ()->
    if @visible then @hide() else @show()

  show: ()->
    @wrapper.empty()
    @visible = true
    @$el.show()
    @hideSearchResults()
    @$('input').val('').focus()

  hide: ()->
    #@$('input').blur()
    #@wrapper.height(0)
    @$el.hide()
    @visible = false
    @editor.codeMirror.focus()

  render: ()->
    @$el.html JST["code_sync/templates/asset_selector"]()
    @wrapper ||= @$('.search-results-wrapper')
    @