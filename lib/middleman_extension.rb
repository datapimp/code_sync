if defined?(Middleman)
  require "middleman-core"
  require "middleman-more"


  module CodeSync::MiddlemanExtension
    class << self
      def registered app
        app.after_configuration do
          puts "Middleman App Configured.  I supposed we could start the manager?"
          puts app.sprockets
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