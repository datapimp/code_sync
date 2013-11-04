$:.unshift File.dirname(__FILE__)

module CodeSync
  require 'code_sync/version'
  require 'code_sync/manager'
  require 'code_sync/processors'
  require 'middleman_extension' if defined?(Middleman)
  require "code_sync/rails" if defined?(::Rails)

  mattr_accessor :watch_assets_filter

  def self.watch_assets_filter
    @@watch_assets_filter ||= /(\.coffee|\.css|\.jst|\.mustache\.js|\.sass|\.emblem|\.hbs|\.handlebars)/
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
