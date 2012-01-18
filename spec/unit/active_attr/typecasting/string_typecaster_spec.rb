require "spec_helper"
require "active_attr/typecasting/string_typecaster"
require "active_support/basic_object"

module ActiveAttr
  module Typecasting
    describe StringTypecaster do
      describe "#call" do
        it "returns the original string for a String" do
          value = "abc"
          subject.call(value).should equal value
        end

        it "returns the string version of a Symbol" do
          subject.call(:value).should eql "value"
        end
      end
    end
  end
end
