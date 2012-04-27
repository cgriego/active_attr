require "spec_helper"
require "active_attr/attribute_definition"

module ActiveAttr
  describe AttributeDefinition do
    subject { described_class.new(:amount, :default => "default") }

    describe "#<=>" do
      it "is nil if the right side is not an #{described_class}" do
        (subject <=> nil).should be_nil
      end

      it "prefers neither when both sides use the same attribute name and options" do
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

      it "returns false when options differ" do
        described_class.new(:amount).should_not == described_class.new(:amount, :type => String)
      end
    end

    describe "#[]" do
      it "reads an attribute option" do
        subject[:default].should == "default"
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
      it "generates attribute definition code for an attribute without options" do
        described_class.new(:first_name).inspect.should == %{attribute :first_name}
      end

      it "generates attribute definition code for an attribute with a single option" do
        described_class.new(:first_name, :type => String).inspect.should == %{attribute :first_name, :type => String}
      end

      it "generates attribute definition code for an attribute with a single option, inspecting the option value" do
        described_class.new(:first_name, :default => "John").inspect.should == %{attribute :first_name, :default => "John"}
      end

      it "generates attribute definition code for an attribute with multiple options sorted alphabetically" do
        expected = %{attribute :first_name, :default => "John", :type => String}
        described_class.new(:first_name, :default => "John", :type => String).inspect.should eq expected
        described_class.new(:first_name, :type => String, :default => "John").inspect.should == expected
      end

      it "generate attribute definition code for an attribute with a string option key" do
        described_class.new(:first_name, "foo" => "bar").inspect.should == %{attribute :first_name, "foo" => "bar"}
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
