CodeSync is a utility which live reloads asset pipeline assets in their running browser sessions, and an
in-browser IDE which allows you to edit your pre-compiled assets (coffeescript, sass, etc) in the browser
and save them to disk.

### Using CodeSync

```ruby
# Gemfile
gem 'code_sync', git: "git@github.com:datapimp/code_sync.git"
```

```coffeescript
# asset manifest
#= require 'code_sync/dependencies'
#= require 'code_sync'
#= require_self

window.codeSyncClient = new CodeSync.Client()
```

Then simply run the codesync process, from within your rails or middleman app:

```
bundle exec codesync start
```

Now when you change assets in the asset pipeline, they will be applied to the browser without refreshing.

### TODO / In Progress

- Sync asset pipeline changes with browser

  - File system watcher to detect changes to asset pipeline
    - Publishes changes to Faye server API

  - Faye server and Browser client for pub/sub notification
    - Change notification API / messaging structure

  - Browser client

  - Command line interface to interact with pub/sub
    - Text editors plugin

  - Detect if running inside of rails, or middleman, and tap into Sprockets env

  - Standalone mode for Sprockets

  - Monkeypatch Sprockets asset include to have identifier in DOM for stylesheets
    - find a way to map style tag href to asset pipeline path

