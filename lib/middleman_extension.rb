if defined?(Middleman)
  require "middleman-core"
  require "middleman-more"


  module CodeSync::MiddlemanExtension
    class << self
      def registered app, options_hash={}

        app.after_configuration do
          unless build?
            pid = fork do
              source = begin
                File.join(app.root, app.source)
              rescue
                File.join(Dir.pwd(),'source')
              end

              CodeSync::Manager.start(root: source,
                sprockets: (sprockets rescue nil),
                forbid_saving: (options_hash[:forbid_saving] == true),
                parent:'middleman'
              )
            end
          end
        end

        trap("SIGINT") do
          Process.kill(9,pid) rescue nil
        end
      end
    end

    module InstanceMethods

    end
  end

  Middleman::Extensions.register(:code_sync) do
    require 'code_sync'
    CodeSync::MiddlemanExtension
  end
end