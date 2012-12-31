require "spec_helper"
require "active_attr/typecasting/integer_typecaster"

module ActiveAttr
  module Typecasting
    describe IntegerTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original integer for a FixNum" do
          value = 2
          typecaster.call(value).should equal value
        end

        it "casts nil to 0" do
          typecaster.call(nil).should eql 0
        end

        it "returns the integer version of a String" do
          typecaster.call("2").should eql 2
        end

        it "returns nil for an object that does not respond to #to_i" do
          typecaster.call(Object.new).should be_nil
        end

        it "returns nil for Float::INFINITY" do
          typecaster.call(1.0 / 0.0).should be_nil
        end

        it "returns nil for Float::NAN" do
          typecaster.call(0.0 / 0.0).should be_nil
        end
      end
    end
  end
end
