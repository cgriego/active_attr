require "spec_helper"
require "active_attr/block_initialization"

module ActiveAttr
  describe BlockInitialization do
    subject { model_class.new("arg") {} }

    let :model_class do
      Class.new do
        include InitializationVerifier
        include BlockInitialization

        def initialize(arg)
          super
        end
      end
    end

    describe "#initialize" do
      it "invokes the superclass initializer" do
        should be_initialized
      end

      it "doesn't raise when not passed a block" do
        expect { model_class.new("arg") }.not_to raise_error
      end

      it "yields the new instance" do
        yielded_instance = nil

        returned_instance = model_class.new("arg") do |yielded|
          yielded_instance = yielded
        end

        returned_instance.should equal yielded_instance
      end
    end
  end
end
