module CodeSync
  class Engine < ::Rails::Engine
    initializer 'code_sync.manager', :before => :build_middleware_stack do |app|
      enabled = (app.config.enable_code_sync_manager == true) rescue false
      forbid_saving = (app.config.forbid_code_sync_save) rescue false

      if enabled && !$rails_rake_task
        CodeSync::Manager.start(sprockets: app.assets,
                                forked: true,
                                root: ::Rails.root.join('app','assets'),
                                forbid_saving: !!forbid_saving)
      end
    end
  end
end
