CodeSync.AssetSelector = Backbone.View.extend
  className: "codesync-asset-selector"

  events:
    "keyup input": "keyHandler"
    "click .search-result": "loadAsset"

  activeSearchResultIndex: -1

  initialize:(options={})->
    Backbone.View::initialize.apply(@, arguments)

    @editor = options.editor

    _.bindAll(@,"keyHandler","loadAsset")

    @sizeWrapper = _.debounce (units)=>
      @wrapper.animate height:"#{ units * 40 }px"
    , 1000

  keyHandler: (e)->
    if e.keyCode is 27
      @hide()
      return

    count = @$('.search-result').length

    if e.keyCode is 40
      @activeSearchResultIndex += 1

      if @activeSearchResultIndex >= count - 1
        @activeSearchResultIndex = count - 1

        @activeEl = @$('.search-result').eq(@activeSearchResultIndex)
        @$('.search-result').removeClass('active').eq(@activeSearchResultIndex).addClass('active')

      return

    if e.keyCode is 38
      @activeSearchResultIndex -= 1

      if @activeSearchResultIndex <= 0
        @activeSearchResultIndex = 0

      @activeEl = @$('.search-result').eq(@activeSearchResultIndex)
      @$('.search-result').removeClass('active').eq(@activeSearchResultIndex).addClass('active')

      return

    if e.keyCode is 13 and @activeSearchResultIndex >= 0
      path = @activeEl.data('path')
      @editor.loadAsset(path)
      @hide()
      return

    if e.keyCode is 13 or e.keyCode is 38 or e.keyCode is 40
      e.preventDefault()
      return

    value = @$('input').val()

    @filterAssetsBy(value)

  loadAsset: (e)->
    el = @$(e.target)
    if path = el.data('path')
      @editor.loadAsset(path)
      @hide()

  filterAssetsBy: (value)->
    return if value.length <= 1

    wrapper = @showSearchResults()

    models = @editor.assetsCollection.select (model)->
      regex = new RegExp("#{value}")
      model.get("description")?.match(regex) || model.get("path")?.match(regex)

    wrapper.empty()

    for model in models
      wrapper.append "<div data-path='#{ model.get('path') }' class='search-result'>#{ model.get('description') }</div>"

    wrapper.height( models.length * 40 )


  showSearchResults: ()->
    @wrapper.fadeIn()
    @wrapper.height(0)
    @wrapper

  toggle: ()->
    if @visible isnt true
      @$el.animate {top:'0px'}, ()=> @show()
    else
      @$el.animate {top:'-50px'}, ()=> @hide()

  show: ()->
    @wrapper.empty()
    @visible = true
    @$el.show()
    @$('input').val('').focus()

  hide: ()->
    @$('input').blur()
    @wrapper.height(0)
    @$el.hide()
    @visible = false
    @editor.codeMirror.focus()

  render: ()->
    @$el.html JST["code_sync/templates/asset_selector"]()
    @wrapper ||= @$('.search-results-wrapper')
    @