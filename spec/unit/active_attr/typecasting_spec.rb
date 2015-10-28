require "spec_helper"
require "active_attr/typecasting"

module ActiveAttr
  describe Typecasting do
    subject(:model) { model_class.new }

    let :model_class do
      Class.new do
        include Typecasting
      end
    end

    describe "#typecast_attribute" do
      it "raises an ArgumentError when a nil type is given" do
        expect { model.typecast_attribute(nil, "foo") }.to raise_error(ArgumentError, "a typecaster must be given")
      end

      it "raises an ArgumentError when the given typecaster argument does not respond to #call" do
        expect { model.typecast_attribute(Object.new, "foo") }.to raise_error(ArgumentError, "a typecaster must be given")
      end

      it "returns the original value when the value is nil" do
        expect(model_class.new.typecast_attribute(double(:call => 1), nil)).to be_nil
      end
    end

    describe "#typecaster_for" do
      it "returns BigDecimalTypecaster for BigDecimal" do
        expect(model.typecaster_for(BigDecimal)).to be_a_kind_of Typecasting::BigDecimalTypecaster
      end

      it "returns BooleanTypecaster for Boolean" do
        expect(model.typecaster_for(Typecasting::Boolean)).to be_a_kind_of Typecasting::BooleanTypecaster
      end

      it "returns DateTypecaster for Date" do
        expect(model.typecaster_for(Date)).to be_a_kind_of Typecasting::DateTypecaster
      end

      it "returns DateTypecaster for Date" do
        expect(model.typecaster_for(DateTime)).to be_a_kind_of Typecasting::DateTimeTypecaster
      end

      it "returns FloatTypecaster for Float" do
        expect(model.typecaster_for(Float)).to be_a_kind_of Typecasting::FloatTypecaster
      end

      it "returns IntegerTypecaster for Integer" do
        expect(model.typecaster_for(Integer)).to be_a_kind_of Typecasting::IntegerTypecaster
      end

      it "returns StringTypecaster for String" do
        expect(model.typecaster_for(String)).to be_a_kind_of Typecasting::StringTypecaster
      end

      it "returns ObjectTypecaster for Object" do
        expect(model.typecaster_for(Object)).to be_a_kind_of Typecasting::ObjectTypecaster
      end
    end
  end
end
