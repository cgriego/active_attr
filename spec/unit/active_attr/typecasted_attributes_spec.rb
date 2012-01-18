require "spec_helper"
require "active_attr/typecasted_attributes"

module ActiveAttr
  describe TypecastedAttributes do
    let :model_class do
      Class.new do
        include TypecastedAttributes

        attribute :amount, :type => String
        attribute :first_name
        attribute :last_name

        def initialize(amount)
          super
          self.amount = amount
        end

        def self.name
          "Foo"
        end
      end
    end

    let :attributeless do
      Class.new do
        include TypecastedAttributes

        def self.name
          "Foo"
        end
      end
    end

    describe ".inspect" do
      it "renders the class name" do
        model_class.inspect.should match /^Foo\(.*\)$/
      end

      it "renders the attribute names and types in alphabetical order, using Object for undeclared types" do
        model_class.inspect.should match "(amount: String, first_name: Object, last_name: Object)"
      end

      it "doesn't format the inspection string for attributes if the model does not have any" do
        attributeless.inspect.should == "Foo"
      end
    end
  end
end
