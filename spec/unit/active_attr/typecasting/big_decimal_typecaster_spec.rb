require "spec_helper"
require "active_attr/typecasting/big_decimal_typecaster"

module ActiveAttr
  module Typecasting
    describe BigDecimalTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original BigDecimal for a BigDecimal" do
          value = BigDecimal("2.0")
          typecaster.call(value).should equal value
        end

        it "casts nil to nil" do
          typecaster.call(nil).should eql nil
        end

        it "casts a numeric String to a BigDecimal" do
          typecaster.call("2").should eql BigDecimal("2.0")
        end

        it "casts an empty String to nil" do
          typecaster.call("").should eql nil
        end

        it "casts an alpha String to a zero BigDecimal" do
          typecaster.call("bob").should eql BigDecimal("0.0")
        end

        it "casts an alpha string coercable object to a zero BigDecimal" do
          typecaster.call(double(to_s: "bob")).should eql BigDecimal("0.0")
        end

        it "casts a Rational to a BigDecimal" do
          typecaster.call(Rational(1, 2)).should eql BigDecimal("0.5")
        end

        it "casts a Float to a BigDecimal" do
          typecaster.call(1.2).should eql BigDecimal("1.2")
        end

        it "cases an Integer to a BigDecimal" do
          typecaster.call(2).should eql BigDecimal("2.0")
        end
      end
    end
  end
end
