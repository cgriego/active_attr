require "spec_helper"
require "active_attr/model"

module ActiveAttr
  describe Model do
    let(:klass) do
      Class.new do
        include Model

        def self.name
          "Foo"
        end
      end
    end

    subject { klass.new }
    it_should_behave_like 'ActiveModel'
  end
end
