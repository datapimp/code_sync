module CodeSync
  class Engine < ::Rails::Engine
    initializer 'code_sync.manager', :after => :build_middleware_stack do |app|
      if app.configuration.enable_codesync_manager
        if ::Rails.env.development?
          CodeSync::Manager.start(sprockets: app.assets, forked: true)
        end
      end
    end
  end
end