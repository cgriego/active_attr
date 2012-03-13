require "bundler/setup"
require "rspec/autorun"
require "active_model"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }
RAILS_3_0 = ActiveModel::VERSION::MAJOR == 3 && ActiveModel::VERSION::MINOR == 0

RSpec.configure do |config|
  config.mock_framework = :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true # default in RSpec 3

  if RAILS_3_0
    config.filter_run_excluding :roles_support => true
  else
    config.filter_run_excluding :roles_support => false
  end
end
