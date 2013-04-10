if defined?(Middleman)
  require "middleman-core"
  require "middleman-more"


  module CodeSync::MiddlemanExtension
    class << self
      def registered app
        app.after_configuration do

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