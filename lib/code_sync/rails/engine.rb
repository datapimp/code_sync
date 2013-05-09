module CodeSync
  class Engine < ::Rails::Engine
    initializer 'code_sync.manager', :before => :build_middleware_stack do |app|
      enabled = (app.config.enable_code_sync_manager == true) rescue false

      if enabled && !$rails_rake_task
        CodeSync::Manager.start(sprockets: app.assets, forked: true)
      end
    end
  end
end