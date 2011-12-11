require "spec_helper"
require "active_attr/attribute_definition"

module ActiveAttr
  describe AttributeDefinition do
    subject { described_class.new(:amount) }

    describe "#<=>" do
      it "is nil if the right side is not an #{described_class}" do
        (subject <=> nil).should be_nil
      end

      it "prefers neither when both sides use the same attribute name and type" do
        (subject <=> subject).should == 0
      end

      it "prefers the left when the attribute names equal and the left type sorts alphabetically before the right side" do
        (described_class.new(:amount, :type => Float) <=> described_class.new(:amount, :type => Integer)).should == -1
      end

      it "prefers the right when the attribute names equal and the right type sorts alphabetically before the left side" do
        (described_class.new(:amount, :type => Integer) <=> described_class.new(:amount, :type => Float)).should == 1
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

      it "returns false when types differ" do
        described_class.new(:amount).should_not == described_class.new(:amount, :type => String)
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

      it "accepts a type option" do
        described_class.new(:amount, :type => Object).type.should == Object
      end

      it "defaults type to Object when not specified" do
        described_class.new(:amount).type.should == Object
      end

      it "constantizes a String for type" do
        described_class.new(:amount, :type => 'String').type.should == String
      end

      it "raises a TypeError for values other than String and Class for type" do
        expect { described_class.new(:amount, :type => 1) }.to raise_error(TypeError, "type must be a Class or String")
      end
    end

    describe "#inspect" do
      it "renders the name and type" do
        subject.inspect.should == "amount: Object"
      end
    end

    describe "#name" do
      it { should respond_to(:name) }
    end

    describe "#requires_typecasting?" do
      let(:attribute) { described_class.new(:amount, :type => String) }
      let(:subclass) { Class.new(String) }

      context "when the value is a subclass of the type" do
        subject { attribute.requires_typecasting?(subclass.new("1.0")) }
        it { should be_false }
      end

      context "when the value is of the same type" do
        subject { attribute.requires_typecasting?("1.0") }
        it { should be_false }
      end

      context "when the value is not of the same type" do
        subject { attribute.requires_typecasting?(1.0) }
        it { should be_true }
      end
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

    describe "#type" do
      it { should respond_to(:type) }
    end
  end
end
