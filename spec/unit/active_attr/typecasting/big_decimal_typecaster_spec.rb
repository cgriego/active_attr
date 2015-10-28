require "spec_helper"
require "active_attr/typecasting/big_decimal_typecaster"

module ActiveAttr
  module Typecasting
    describe BigDecimalTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original BigDecimal for a BigDecimal" do
          value = BigDecimal.new("2.0")
          expect(typecaster.call(value)).to equal value
        end

        it "casts nil to a zero BigDecimal" do
          expect(typecaster.call(nil)).to eql BigDecimal.new("0.0")
        end

        it "casts a numeric String to a BigDecimal" do
          expect(typecaster.call("2")).to eql BigDecimal.new("2.0")
        end

        it "casts a alpha String to a zero BigDecimal" do
          expect(typecaster.call("bob")).to eql BigDecimal.new("0.0")
        end

        it "casts a Rational to a BigDecimal" do
          expect(typecaster.call(Rational(1, 2))).to eql BigDecimal.new("0.5")
        end

        it "casts a Float to a BigDecimal" do
          expect(typecaster.call(1.2)).to eql BigDecimal.new("1.2")
        end

        it "cases an Integer to a BigDecimal" do
          expect(typecaster.call(2)).to eql BigDecimal.new("2.0")
        end
      end
    end
  end
end
