#= require ./keylauncher.min
#= require_self
#= require code_sync/client
#= require code_sync/editor

root = @

if typeof(exports) isnt "undefined"
  CodeSync = exports
else
  CodeSync = root.CodeSync = {}

CodeSync.VERSION = "0.0.4"

CodeSync.setSequence = (sequence="sync")->
  KeyLauncher.onSequence sequence, ()->
    CodeSync.AssetEditor.getInstance().toggle()

CodeSync.setHotKey = (hotkey="command+j")->
  KeyLauncher.on hotkey, ()->
    CodeSync.AssetEditor.getInstance().toggle()
