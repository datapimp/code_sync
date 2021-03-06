$:.push File.expand_path("../lib", __FILE__)
require 'code_sync/version'

Gem::Specification.new do |s|
  s.name          = "code_sync"
  s.version       = CodeSync::Version
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Jonathan Soeder"]
  s.email         = ["jonathan.soeder@gmail.com"]
  s.homepage      = "http://codesync.io"
  s.summary       = "Turn your browser into a coffeescript / sass canvas"
  s.description   = ""

  s.add_dependency 'faye'
  s.add_dependency 'thin'
  s.add_dependency 'listen'
  s.add_dependency 'sprockets'
  s.add_dependency 'pry'
  s.add_dependency 'thor'
  s.add_dependency 'slim'
  s.add_dependency 'skim'
  s.add_dependency 'rack-webconsole-pry'
  s.add_dependency 'rb-fsevent', '~> 0.9'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end