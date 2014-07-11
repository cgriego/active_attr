require "bundler/setup"
require "active_model/version"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.filter_run_excluding :active_model_version => lambda { |requirement|
    !Gem::Requirement.create(requirement).satisfied_by?(Gem::Version.new(ActiveModel::VERSION::STRING))
  }

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = [:expect, :should]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
    mocks.verify_partial_doubles = true
  end
end
