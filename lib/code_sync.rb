$:.unshift File.dirname(__FILE__)

module CodeSync
  require 'code_sync/version'
  require 'code_sync/manager'

  if defined?(Middleman)
    require 'middleman_extension'
  end

  if defined?(::Rails)
    require "code_sync/rails"
  end

  def self.gem_assets_root
    File.join(File.dirname(__FILE__), '..')
  end
end

# When using outside of Rails.
# Allows for using Rails asset pipline gems.
unless defined? ::Rails
  module Rails
    def self.version
      "3.2.13"
    end

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