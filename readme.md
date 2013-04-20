CodeSync is a utility which live reloads asset pipeline assets in their running browser sessions, and an
in-browser IDE which allows you to edit your pre-compiled assets (coffeescript, sass, etc) in the browser
and save them to disk.

### Using with Rails
```
# config/initializers/code_sync.rb
if Rails.env.development?
  CodeSync::Manager.start(forked: true, sprockets: Rails.application.assets )
end
```

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

Now when you change assets in the asset pipeline, they will be applied to the browser without refreshing.
