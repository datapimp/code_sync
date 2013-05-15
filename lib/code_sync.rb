$:.unshift File.dirname(__FILE__)

module CodeSync
  require 'code_sync/version'
  require 'code_sync/manager'
  require 'code_sync/processors'

  if defined?(Middleman)
    require 'middleman_extension'
  end

  if defined?(::Rails)
    require "code_sync/rails"
  end

  def self.gem_assets_root
    File.join(File.dirname(__FILE__), '..')
  end

  def self.allow_saving?
    !ENV['CODE_SYNC_SAVE_DISABLED'].nil?
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