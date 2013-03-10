require 'machinist/active_record'
require 'sham'
require 'faker'

require File.expand_path('../support/schema.rb', __FILE__)
require File.expand_path('../support/models.rb', __FILE__)

Sham.define do
  name     { Faker::Name.name }  
  salary   {|index| 30000 + (index * 1000)}
end

RSpec.configure do |config|
  config.before(:suite) do
    Models.make
  end

  config.before(:all)   { Sham.reset(:before_all) }
  config.before(:each)  { Sham.reset(:before_each) }  
end

require 'smooth'