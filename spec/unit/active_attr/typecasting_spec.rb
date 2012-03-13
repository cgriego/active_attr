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
        it "returns nil" do
          subject.typecast_attribute(Class.new, mock).should be_nil
        end
      end

      context "when the value is nil" do
        let(:name) { nil }
        let(:model) { model_class.new }
        subject { model.typecast_attribute(type, name) }

        it "returns the original value" do
          should be_nil
        end
      end

      describe "typecaster resolution" do
        let(:model) { model_class.new }
        let(:value) { mock }

        it "calls BigDecimalTypecaster when typecasting to BigDecimal" do
          Typecasting::BigDecimalTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(BigDecimal, value)
        end

        it "calls BooleanTypecaster when typecasting to Boolean" do
          Typecasting::BooleanTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(Typecasting::Boolean, value)
        end

        it "calls DateTypecaster when typecasting to Date" do
          Typecasting::DateTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(Date, value)
        end

        it "calls DateTypecaster when typecasting to Date" do
          Typecasting::DateTimeTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(DateTime, value)
        end

        it "calls FloatTypecaster when typecasting to Float" do
          Typecasting::FloatTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(Float, value)
        end

        it "calls IntegerTypecaster when typecasting to Integer" do
          Typecasting::IntegerTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(Integer, value)
        end

        it "calls StringTypecaster when typecasting to String" do
          Typecasting::StringTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(String, value)
        end

        it "calls ObjectTypecaster when typecasting to Object" do
          Typecasting::ObjectTypecaster.any_instance.should_receive(:call).with(value)
          model.typecast_attribute(Object, value)
        end
      end
    end
  end
end
