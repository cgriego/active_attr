require "spec_helper"
require "active_attr/attribute_definition"

module ActiveAttr
  describe AttributeDefinition do
    subject { described_class.new(:amount) }

    describe "#<=>" do
      it "is nil if the right side is not an #{described_class}" do
        (subject <=> nil).should be_nil
      end

      it "prefers neither when both sides use the same attribute name" do
        (subject <=> subject).should == 0
      end

      it "prefers the left side when the left side name sorts alphabetically before the right side name" do
        (described_class.new(:amount) <=> described_class.new(:quantity)).should == -1
      end

      it "prefers the right side when the right side name sorts alphabetically before the left side name" do
        (described_class.new(:quantity) <=> described_class.new(:amount)).should == 1
      end
    end

    describe "#==" do
      it "returns true when the attribute name is equal" do
        described_class.new(:amount).should == described_class.new(:amount)
      end

      it "returns false when another object is compared" do
        described_class.new(:amount).should_not == Struct.new(:name).new(:amount)
      end
    end

    describe "#initialize" do
      it "raises an ArgumentError when no arguments" do
        expect { described_class.new }.to raise_error ArgumentError
      end

      it "assigns the first argument to name" do
        described_class.new(:amount).name.should == :amount
      end

      it "converts a String attribute name to a Symbol" do
        described_class.new('amount').name.should == :amount
      end

      it "raises a TypeError when the attribute name does not respond to #to_sym" do
        expect { described_class.new(Object.new) }.to raise_error(TypeError, "can't convert Object into Symbol")
      end
    end

    describe "#inspect" do
      it "renders the name" do
        subject.inspect.should == "amount"
      end
    end

    describe "#name" do
      it { should respond_to(:name) }
    end

    describe "#to_s" do
      it "renders the name as a String" do
        subject.to_s.should == "amount"
      end
    end

    describe "#to_sym" do
      it "renders the name as a Symbol" do
        subject.to_sym.should == :amount
      end
    end
  end
end
