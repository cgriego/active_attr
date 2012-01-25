require "spec_helper"
require "active_attr/typecasting/boolean_typecaster"
require "bigdecimal"

module ActiveAttr
  module Typecasting
    describe BooleanTypecaster do
      describe "#call" do
        it "returns true for true" do
          subject.call(true).should equal true
        end

        it "returns false for false" do
          subject.call(false).should equal false
        end

        it "casts nil to false" do
          subject.call(nil).should equal false
        end

        it "casts an Object to true" do
          subject.call(Object.new).should equal true
        end

        context "when the value is a String" do
          it "casts an empty String to false" do
            subject.call("").should equal false
          end

          it "casts a non-empty String to true" do
            subject.call("abc").should equal true
          end

          {
            "t" => true,
            "f" => false,
            "T" => true,
            "F" => false,
            # http://yaml.org/type/bool.html
            "y" => true,
            "Y" => true,
            "yes" => true,
            "Yes" => true,
            "YES" => true,
            "n" => false,
            "N" => false,
            "no" => false,
            "No" => false,
            "NO" => false,
            "true" => true,
            "True" => true,
            "TRUE" => true,
            "false" => false,
            "False" => false,
            "FALSE" => false,
            "on" => true,
            "On" => true,
            "ON" => true,
            "off" => false,
            "Off" => false,
            "OFF" => false,
          }.each_pair do |value, result|
            it "casts #{value.inspect} to #{result.inspect}" do
              subject.call(value).should equal result
            end
          end
        end

        context "when the value is Numeric" do
          it "casts 0 to false" do
            subject.call(0).should equal false
          end

          it "casts 1 to true" do
            subject.call(1).should equal true
          end

          it "casts 0.0 to false" do
            subject.call(0.0).should equal false
          end

          it "casts 0.1 to true" do
            subject.call(0.1).should equal true
          end

          it "casts a zero BigDecimal to false" do
            subject.call(BigDecimal.new("0.0")).should equal false
          end

          it "casts a non-zero BigDecimal to true" do
            subject.call(BigDecimal.new("0.1")).should equal true
          end

          it "casts -1 to true" do
            subject.call(-1).should equal true
          end

          it "casts -0.0 to false" do
            subject.call(-0.0).should equal false
          end

          it "casts -0.1 to true" do
            subject.call(-0.1).should equal true
          end

          it "casts a negative zero BigDecimal to false" do
            subject.call(BigDecimal.new("-0.0")).should equal false
          end

          it "casts a negative BigDecimal to true" do
            subject.call(BigDecimal.new("-0.1")).should equal true
          end
        end

        context "when the value is the String version of a Numeric" do
          it "casts '0' to false" do
            subject.call("0").should equal false
          end

          it "casts '1' to true" do
            subject.call("1").should equal true
          end

          it "casts '0.0' to false" do
            subject.call("0.0").should equal false
          end

          it "casts '0.1' to true" do
            subject.call("0.1").should equal true
          end

          it "casts '-1' to true" do
            subject.call("-1").should equal true
          end

          it "casts '-0.0' to false" do
            subject.call("-0.0").should equal false
          end

          it "casts '-0.1' to true" do
            subject.call("-0.1").should equal true
          end
        end
      end
    end
  end
end
