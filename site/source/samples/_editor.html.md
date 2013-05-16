The editor which gets included with CodeSync can be toggled on and off with a key command of your choosing.

You can pass options for the AssetEditor as the second argument.

The editor is going to be running on this page.  You can enable it by pressing `ctrl+j`, or by clicking at the tab at the top of the screen.

```javascript
  // start the editor in SCSS mode, with VIM keybindings
  CodeSync.AssetEditor.setHotKey('ctrl+j', {
    startMode:"scss",
    keyBindings: "vim"
  });
```

**Note About Dependencies**

The CodeSync editor depends on Backbone.js, Underscore.js, Zepto.js, and CodeMirror.  If you already have these libraries in your project, you're a boss obviously.

To only include the CodeSync assets without any of its dependencies, you can change the way you include the codesync library by only bringing in the code_sync_basic.js javascript.
