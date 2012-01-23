require "spec_helper"
require "active_attr/typecasting/object_typecaster"

module ActiveAttr
  module Typecasting
    describe ObjectTypecaster do
      describe "#call" do
        it "returns the original object for any object" do
          value = mock
          subject.call(value).should equal value
        end
      end
    end
  end
end
