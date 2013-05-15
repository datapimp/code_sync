The editor which gets included with CodeSync can be toggled on and off with a key command of your choosing.

You can pass options for the AssetEditor as the second argument.

The editor is going to be running on this page.  You can enable it by pressing `ctrl+j`, or by clicking at the tab at the top of the screen.

```javascript
  CodeSync.AssetEditor.setHotKey('ctrl+j', {defaultFileType:"sass", defaultExtension:".css.sass"})
```