$:.unshift File.dirname(__FILE__)

module CodeSync
  require 'code_sync/version'
  require 'code_sync/publisher'
  require 'code_sync/server'
  require 'code_sync/sprockets_adapter'
  require 'code_sync/watcher'
end