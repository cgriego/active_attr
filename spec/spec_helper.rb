require "bundler/setup"
require "rspec/autorun"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.mock_framework = :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true # default in RSpec 3
end
