require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => ["spec"]

RSpec::Core::RakeTask.new

namespace :spec do
  desc "Run RSpec specs with code coverate analysis"
  RSpec::Core::RakeTask.new(:cov) do |spec|
    spec.rspec_opts = "--format nested --format SpecCoverage"
  end
end
