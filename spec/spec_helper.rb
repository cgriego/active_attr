require "bundler/setup"
require "rspec/autorun"
require "active_support"
require "active_model/mass_assignment_security"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.mock_framework = :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true # default in RSpec 3

  ActiveModelCheck = Class.new do
    include ActiveModel::MassAssignmentSecurity
    def old_rails?
      method(:sanitize_for_mass_assignment).arity.abs == 1
    end
  end

  if ActiveModelCheck.new.old_rails?
    puts "old rails detected"
    config.filter_run_excluding :roles_support => true
  else
    puts "new rails detected"
    config.filter_run_excluding :without_roles_support => true
  end
end
