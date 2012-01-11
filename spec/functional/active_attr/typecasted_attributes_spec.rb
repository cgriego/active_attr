require "spec_helper"
require "active_attr/typecasted_attributes"
require "active_attr/mass_assignment"

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

      it "renders the attribute names and types in alphabetical order" do
        model_class.inspect.should match "(amount: String, first_name: Object, last_name: Object)"
      end

      it "doesn't format the inspection string for attributes if the model does not have any" do
        attributeless.inspect.should == "Foo"
      end
    end

    describe "#read_attribute" do
      context "when assigning nil" do
        subject { model_class.new(nil) }

        it "returns nil" do
          subject.read_attribute(:amount).should be_nil
        end
      end

      context "when the assigned value is the requested type" do
        subject { model_class.new("1.0") }

        it "returns the value" do
          subject.read_attribute(:amount).should == "1.0"
        end
      end
    end
  end
end
