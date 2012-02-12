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

        it "casts nil to a zero BigDecimal" do
          subject.call(nil).should eql BigDecimal.new("0.0")
        end

        it "casts a numeric String to a BigDecimal" do
          subject.call("2").should eql BigDecimal.new("2.0")
        end

        it "casts a alpha String to a zero BigDecimal" do
          subject.call("bob").should eql BigDecimal.new("0.0")
        end

        it "casts a Rational to a BigDecimal" do
          subject.call(Rational(1, 2)).should eql BigDecimal.new("0.5")
        end

        it "casts a Float to a BigDecimal" do
          subject.call(1.2).should eql BigDecimal.new("1.2")
        end

        it "cases an Integer to a BigDecimal" do
          subject.call(2).should eql BigDecimal.new("2.0")
        end
      end
    end
  end
end
