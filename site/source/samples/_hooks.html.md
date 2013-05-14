```coffeescript
# changeInfo is a hash which has a name and path property
CodeSync.onScriptChange = (changeInfo)->
  @doSomethingWithChangeInfo(changeInfo)

CodeSync.onStylesheetChange = (changeInfo)->
  console.log "Reloaded the stylesheet"
```