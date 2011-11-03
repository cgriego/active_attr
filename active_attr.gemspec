# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_attr/version"

Gem::Specification.new do |s|
  s.name        = "active_attr"
  s.version     = ActiveAttr::VERSION
  s.authors     = ["Chris Griego", "Ben Poweski"]
  s.email       = ["cgriego@gmail.com", "bpoweski@gmail.com"]
  s.homepage    = "https://github.com/cgriego/active_attr"
  s.summary     = %q{What ActiveModel left out}
  s.description = %q{Create plain old ruby models without reinventing the wheel.}

  s.rubyforge_project = "active_attr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activemodel",   "~> 3.1"
  s.add_runtime_dependency "activesupport", "~> 3.1"

  s.add_development_dependency "bundler",      "~> 1.0"
  s.add_development_dependency "factory_girl", "~> 2.2"
  s.add_development_dependency "rake",         "~> 0.9.0"
  s.add_development_dependency "rspec",        "~> 2.6"
end
