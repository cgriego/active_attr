require "spec_helper"
require "active_attr/basic_model"

module ActiveAttr
  describe BasicModel do
    let(:model_class) do
      Class.new do
        include BasicModel

        def self.name
          "Foo"
        end
      end
    end

    subject { model_class.new }
    it_should_behave_like "ActiveModel"
  end
end
