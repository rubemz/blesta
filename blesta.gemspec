# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blesta/support/version"

Gem::Specification.new do |s|
  s.name        = "blesta"
  s.version     = Blesta::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Mazzi"]
  s.email       = ["jmazzi@site5.com"]
  s.homepage    = ""
  s.summary     = %q{A Ruby library for working with the Blesta Resellers API}
  s.description = %q{A Ruby library for working with the Blesta Resellers API}

  s.rubyforge_project = "blesta"

  s.add_development_dependency 'rspec', '~> 2.10.0'
  s.add_development_dependency 'awesome_print', '~> 1.0.2'
  s.add_development_dependency 'rake', '~> 0.9.2.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ["lib"]
end
