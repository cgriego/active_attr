require "active_model/lint"
require "test/unit/assertions"

shared_examples_for "ActiveModel" do
  include ActiveModel::Lint::Tests
  include Test::Unit::Assertions

  before { @model = subject }

  ActiveModel::Lint::Tests.public_instance_methods.map(&:to_s).grep(/^test/).each do |test|
    example test.gsub("_", " ") do
      send test
    end
  end
end
