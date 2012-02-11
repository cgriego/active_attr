require "spec_helper"
require "active_attr/typecasting/big_decimal_typecaster"

module ActiveAttr
  module Typecasting
    describe BigDecimalTypecaster do
      describe "#call" do
        it "returns the original BigDecimal for a BigDecimal" do
          value = BigDecimal.new("2.0")
          subject.call(value).should equal value
        end

        it "casts nil to 0.0" do
          subject.call(nil).should eql BigDecimal.new("0.0")
        end

        it "returns the BigDecimal version of a String" do
          subject.call("2").should eql BigDecimal.new("2.0")
        end

        it "returns 0.0 for non decimals" do
          subject.call("bob").should eql BigDecimal.new("0.0")
        end

        it "returns #to_d for Rationals" do
          value = Rational(1, 2)
          subject.call(value).should eql BigDecimal.new("0.5")
        end
      end
    end
  end
end
