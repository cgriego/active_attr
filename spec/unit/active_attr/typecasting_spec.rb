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
      let(:type) { String }

      it "raises an ArgumentError when a nil type is given" do
        expect { subject.typecast_attribute(nil, "foo") }.to raise_error(ArgumentError, "a Class must be given")
      end

      context "when there is no way to typecast the value" do
        let(:value) { mock("SomeRandomValue") }

        it "returns nil" do
          subject.stub(:typecast_value).and_return(nil)
          subject.typecast_attribute(type, value).should be_nil
        end
      end

      context "when the value is nil" do
        let(:name) { nil }
        let(:model) { model_class.new }
        subject { model.typecast_attribute(type, name) }

        it "returns the original value" do
          should eql name
        end

        it "does not call try to convert the value" do
          model.should_not_receive(:typecast_value)
          subject
        end
      end
    end

    describe "#typecast_value" do
      let(:model) { model_class.new }
      subject { model.typecast_value(type, value) }
      let(:value) { mock }

      it "calls DateTypecaster when typecasting to Date" do
        Typecasting::DateTypecaster.any_instance.should_receive(:call).with(value)
        model.typecast_value(Date, value)
      end

      it "calls DateTypecaster when typecasting to Date" do
        Typecasting::DateTimeTypecaster.any_instance.should_receive(:call).with(value)
        model.typecast_value(DateTime, value)
      end

      it "calls FloatTypecaster when typecasting to Float" do
        Typecasting::FloatTypecaster.any_instance.should_receive(:call).with(value)
        model.typecast_value(Float, value)
      end

      it "calls IntegerTypecaster when typecasting to Integer" do
        Typecasting::IntegerTypecaster.any_instance.should_receive(:call).with(value)
        model.typecast_value(Integer, value)
      end

      it "calls StringTypecaster when typecasting to String" do
        Typecasting::StringTypecaster.any_instance.should_receive(:call).with(value)
        model.typecast_value(String, value)
      end

      it "calls ObjectTypecaster when typecasting to Object" do
        Typecasting::ObjectTypecaster.any_instance.should_receive(:call).with(value)
        model.typecast_value(Object, value)
      end
    end
  end
end
