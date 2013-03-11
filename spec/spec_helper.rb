unless defined?(CodeSync)
  Bundler.require(:test)
end

require 'code_sync'

module CodeSync
  class << self
    attr_accessor :spec_root
  end

  self.spec_root = File.dirname(__FILE__) 
end

RSpec.configure do |config|
  config.before(:suite) do

  end
end


