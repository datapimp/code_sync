CodeSync.DocumentManager = Backbone.View.extend
  initialize: (options={})->
    @editor = options.editor

    @$el.append "<div class='document-tabs-container' />"

    @openDocuments = new CodeSync.Documents()

    @openDocuments.on "add", @renderTabs, @
    @openDocuments.on "remove", @renderTabs, @
    @openDocuments.on "change:display", @renderTabs, @

    @projectAssets = new CodeSync.ProjectAssets()

    @state = new Backbone.Model
      currentDocument: undefined

    @state.on "change:currentDocument", @highlightActiveDocumentTab, @

  renderTabs: ()->
    container = @$('.document-tabs-container').empty()

    for documentModel in @openDocuments.models
      container.append "<div class='document-tab'>#{ documentModel.get('display') }</div>"

    @

  highlightActiveDocumentTab: ()->

  getCurrentDocument: ()->
    @state.get("currentDocument")

  loadDocument: (documentModel)->
    @state.set "currentDocument", documentModel
    @editor.codeMirror.swapDoc documentModel.toCodeMirrorDocument()

  createAdHocDocument: ()->
    @openDocuments.add
      id: 1
      extension: ".css.sass"
      name: "scratch-pad"
      mode: "sass"
      path: undefined
      display: "Scratch Pad"
      contents: "// Feel free to experiment with Sass"

    @openDocuments.get(1)

  render: ()->
    @loadDocument @createAdHocDocument()
    @