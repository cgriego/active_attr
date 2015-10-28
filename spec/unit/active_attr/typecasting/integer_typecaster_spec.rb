require "spec_helper"
require "active_attr/typecasting/integer_typecaster"

module ActiveAttr
  module Typecasting
    describe IntegerTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original integer for a FixNum" do
          value = 2
          expect(typecaster.call(value)).to equal value
        end

        it "casts nil to 0" do
          expect(typecaster.call(nil)).to eql 0
        end

        it "returns the integer version of a String" do
          expect(typecaster.call("2")).to eql 2
        end

        it "returns nil for an object that does not respond to #to_i" do
          expect(typecaster.call(Object.new)).to be_nil
        end

        it "returns nil for Float::INFINITY" do
          expect(typecaster.call(1.0 / 0.0)).to be_nil
        end

        it "returns nil for Float::NAN" do
          expect(typecaster.call(0.0 / 0.0)).to be_nil
        end
      end
    end
  end
end
