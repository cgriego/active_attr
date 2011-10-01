require 'spec_helper'
require 'active_attr/attribute_definition'

module ActiveAttr
  describe AttributeDefinition do
    describe "#==" do
      it "returns true when the attribute name is equal" do
        described_class.new(:amount).should == described_class.new(:amount)
      end

      it "returns false when another object is compared" do
        described_class.new(:amount).should_not == Struct.new(:name).new(:amount)
      end
    end

    describe "#initialize" do
      it "requires an attribute name" do
        expect { described_class.new }.to raise_error
      end

      it "assigns the attribute name" do
        described_class.new(:amount).name.should == :amount
      end

      it "converts a String attribute name to a Symbol" do
        described_class.new('amount').name.should == :amount
      end

      it "raises a TypeError when the attribute name does not respond to #to_sym" do
        expect { described_class.new(Object.new) }.to raise_error(TypeError, "can't convert Object into Symbol")
      end
    end
  end
end
