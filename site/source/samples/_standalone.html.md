If you are not running rails, or middleman, or if you don't want the code sync manager to be running every time you're in development, the gem ships with an executable.

This will start an instance of the codesync manager in the root of whatever project you want to watch for asset changes.  By default it will look for asset folders
named

- javascripts
- stylesheets
- app/assets/javascripts
- app/assets/stylesheets
- assets/javascripts
- assets/stylesheets

To install:

```bash
gem install code_sync

# now you can use the codesync executable
codesync start
```

You will want to include the code sync libraries and css in your project.

**Note** the CSS is only required if you want to use the editor.

```html
<html>
  <head>
    <link rel="stylesheet" href="//datapimp.github.io/code_sync/vendor/assets/stylesheets/code_sync.css" />
  </head>
  <body>
    <script type="text/javascript" src="//datapimp.github.io/code_sync/vendor/assets/javascripts/code_sync.js"
  </body>
</html>
```

