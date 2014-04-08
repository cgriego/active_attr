require "spec_helper"
require "active_attr/typecasting/string_typecaster"

module ActiveAttr
  module Typecasting
    describe StringTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original string for a String" do
          value = "abc"
          typecaster.call(value).should equal value
        end

        it "casts nil to an empty String" do
          typecaster.call(nil).should eql ""
        end

        it "returns the string version of a Symbol" do
          typecaster.call(:value).should eql "value"
        end
      end
    end
  end
end
