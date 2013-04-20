#= require_self
#= require code_sync/client
#= require code_sync/editor

root = @

if typeof(exports) isnt "undefined"
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

CodeSync.VERSION = "0.2.0"

CodeSync.setSequence = (sequence="sync")->
  KeyLauncher.onSequence sequence, ()->
    CodeSync.AssetEditor.getInstance().toggle()

CodeSync.setHotKey = (hotkey="command+j")->
  KeyLauncher.on hotkey, ()->
    CodeSync.util.loadStylesheet "http://localhost:9295/assets/code_sync.css", {}, ()->
      CodeSync.AssetEditor.getInstance().toggle()
