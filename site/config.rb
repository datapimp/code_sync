set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :sprockets
activate :code_sync

Skim::Engine.default_options[:use_asset] = true

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true
activate :syntax, :cssclass => "codehilite"

activate :directory_indexes

configure :build do
  activate :minify_css
  #activate :minify_javascript
  activate :relative_assets
end

after_build do
  `cp build/javascripts/code_sync.js ../vendor/assets/javascripts`
  `cp build/javascripts/code_sync_basic.js ../vendor/assets/javascripts`
  `cp build/stylesheets/code_sync.css ../vendor/assets/stylesheets`
end