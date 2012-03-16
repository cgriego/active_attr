#!/usr/bin/env rake

require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

task :spec => %w(spec:units spec:functionals)

namespace :spec do
  desc "Run RSpec specs with code coverate analysis"
  RSpec::Core::RakeTask.new(:cov) do |spec|
    spec.rspec_opts = "--format nested --format SpecCoverage"
  end

  desc "Run RSpec unit specs"
  RSpec::Core::RakeTask.new(:units) do |spec|
    spec.pattern = "spec/unit/**/*_spec.rb"
    spec.ruby_opts = "-w"
  end

  desc "Run RSpec functional specs"
  RSpec::Core::RakeTask.new(:functionals) do |spec|
    spec.pattern = "spec/functional/**/*_spec.rb"
    spec.ruby_opts = "-w"
  end
end
