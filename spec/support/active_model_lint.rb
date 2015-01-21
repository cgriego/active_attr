require "active_model/lint"

shared_examples_for "ActiveModel" do
  include ActiveModel::Lint::Tests

  begin
    require "minitest/assertions"
    include Minitest::Assertions
  rescue LoadError
    require "minitest/unit"
    include MiniTest::Assertions
  end

  attr_writer :assertions

  def assertions
    @assertions ||= 0
  end

  before { @model = subject }

  ActiveModel::Lint::Tests.public_instance_methods.map(&:to_s).grep(/^test/).each do |test|
    example test.gsub("_", " ") do
      send test
    end
  end
end
