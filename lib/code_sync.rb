$:.unshift File.dirname(__FILE__)

module CodeSync
  require 'code_sync/version'
  require 'code_sync/publisher'
  require 'code_sync/server'
  require 'code_sync/temp_asset'
  require 'code_sync/sprockets_adapter'
  require 'code_sync/manager'
  require 'code_sync/watcher'
  require 'code_sync/command_runner'
  require 'middleman_extension'

  def self.gem_assets_root
    File.join(File.dirname(__FILE__), '..')
  end
end

# When using outside of Rails.
# Allows for using Rails asset pipline gems.
unless defined? Rails
  module Rails
    def self.env
      Class.new do
        def test?
          false
        end
      end.new
    end

    class Engine
    end
  end
end