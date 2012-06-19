# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chronologic/version"

Gem::Specification.new do |s|
  s.name     = 'chronologic'
  s.version  = Chronologic::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors  = ["Adam Keys", "Scott Raymond", "Mike Hagedorn"]
  s.email    = 'mike.hagedorn@hp.com'
  s.homepage = 'http://github.com/gowalla/chronologic'
  s.summary     = "Chronologic is a database for activity feeds."
  s.description = "Chronologic uses Cassandra to fetch and store activity feeds. Quickly."

  s.rubyforge_project = "chronologic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('cassandra',["~> 0.12.3"])
  s.add_dependency('httparty')
  s.add_dependency('hashie')
  s.add_dependency('multi_json')
  s.add_dependency('activesupport', ["~> 3.1.0"])
  s.add_dependency('i18n', ["~> 0.6.0"])
  s.add_dependency('sinatra', ["~> 1"])
  s.add_runtime_dependency "eventmachine"
  s.add_runtime_dependency "thin"
  s.add_runtime_dependency "thor"

  # HAX
   s.add_dependency('thrift', ['~> 0.8.0'])
   s.add_dependency('thrift_client', ['~> 0.8.1'])
  # s.add_dependency('simple_uuid', ['~> 0.1.0'])
end

