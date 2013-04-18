if defined?(Middleman)
  require "middleman-core"
  require "middleman-more"


  module CodeSync::MiddlemanExtension
    class << self
      def registered app
        app.after_configuration do
          fork do
            source = begin
              File.join(app.root, app.source)
            rescue
              File.join(Dir.pwd(),'source')
            end

            CodeSync::Manager.start(root: source, sprockets: (sprockets rescue nil), parent:'middleman')
          end
        end

        trap("SIGINT") do
          puts "Caught sigint"
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