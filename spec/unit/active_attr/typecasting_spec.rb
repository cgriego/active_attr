require "spec_helper"
require "active_attr/typecasting"

module ActiveAttr
  describe Typecasting do
    subject { model_class.new }

    let :model_class do
      Class.new do
        include Typecasting
      end
    end

    describe "#typecast_attribute" do
      let(:attribute) { AttributeDefinition.new(:name, :type => String) }

      it "raises an ArgumentError when a nil attribute is given" do
        expect { subject.typecast_attribute(nil, "foo") }.to raise_error(ArgumentError, "an AttributeDefinition must be given")
      end

      context "when typecasting is required" do
        it "prefers to call value#typecast_to_type" do
          subject.stub(:custom_typecast_value).and_return("foo")
          subject.typecast_attribute(attribute, mock("SomeValue")).should == "foo"
        end
      end

      context "when there is no way to typecast the value" do
        let(:value) { mock("SomeRandomValue") }

        it "returns the value" do
          subject.stub(:custom_typecast_value).and_return(nil)
          subject.stub(:typecast_value).and_return(nil)
          subject.typecast_attribute(attribute, value).should == value
        end
      end

      context "when typecasting is not required" do
        let(:name) { "Ben" }
        let(:model) { model_class.new }
        subject { model.typecast_attribute(attribute, name) }

        it "returns the original value" do
          should eql name
        end

        it "does not call try to convert the value" do
          model.should_not_receive(:custom_typecast_value)
          model.should_not_receive(:typecast_value)
          subject
        end
      end
    end

    describe "#custom_typecast_value" do
      let(:model) { model_class.new }
      let(:attribute) { AttributeDefinition.new(:name, :type => String) }

      subject { model.custom_typecast_value(attribute, value) }

      context "when a custom typecasting method exists on the value" do
        let(:value) { mock("CustomValue", :typecast_to_string => "custom") }

        it "returns the result of the method" do
          should == "custom"
        end
      end

      context "when no custom typecasting method exists on the value" do
        let(:value) { mock("CustomValue") }
        it { should be_nil }
      end
    end

    describe "#typecast_value" do
      let(:model) { model_class.new }
      subject { model.typecast_value(attribute, value) }

      context "when typecasting to String" do
        let(:attribute) { AttributeDefinition.new(:name, :type => String) }
        let(:value) { mock(:to_s => "Ben") }

        it "calls #to_s" do
          should == "Ben"
        end
      end

      context "when typecasting to Float" do
        let(:attribute) { AttributeDefinition.new(:amount, :type => Float) }
        let(:value) { mock(:to_f => 1.0) }

        it "calls #to_f" do
          should == 1.0
        end
      end

      context "when typecasting to Integer" do
        let(:attribute) { AttributeDefinition.new(:amount, :type => Integer) }
        let(:value) { mock(:to_i => 1) }

        it "calls #to_i" do
          should == 1
        end
      end

      context "when typecasting to Array" do
        let(:attribute) { AttributeDefinition.new(:amount, :type => Array) }
        let(:value) { mock(:to_a => []) }

        it "calls #to_a" do
          should == []
        end
      end

      context "when typecasting to Date" do
        let(:attribute) { AttributeDefinition.new(:amount, :type => Date) }
        let(:value) { mock(:to_date => date) }
        let(:date) { Date.parse("2012-01-01") }

        it "calls #to_date" do
          should == date
        end
      end

      context "when typecasting to DateTime" do
        let(:attribute) { AttributeDefinition.new(:amount, :type => DateTime) }
        let(:value) { mock(:to_datetime => datetime) }
        let(:datetime) { DateTime.new }

        it "calls #to_datetime" do
          should == datetime
        end
      end

      context "when typecasting to Time" do
        let(:attribute) { AttributeDefinition.new(:amount, :type => Time) }
        let(:value) { mock(:to_time => time) }
        let(:time) { Time.now }

        it "calls #to_time" do
          should == time
        end
      end
    end
  end
end