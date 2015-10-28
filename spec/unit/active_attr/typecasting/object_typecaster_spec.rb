require "spec_helper"
require "active_attr/typecasting/object_typecaster"

module ActiveAttr
  module Typecasting
    describe ObjectTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original object for any object" do
          value = double
          expect(typecaster.call(value)).to equal value
        end
      end
    end
  end
end
