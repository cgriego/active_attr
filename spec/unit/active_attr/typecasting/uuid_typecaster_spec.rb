require "spec_helper"
require "active_attr/typecasting/uuid_typecaster"

module ActiveAttr
  module Typecasting
    describe UUIDTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original string for a UUID" do
          value = "6ed806a8-60ec-4930-ae63-9075bf37ca41"
          typecaster.call(value).should equal value
        end

        it "returns nil for an invalid UUID" do
          typecaster.call("6ed806a8-60ec-4930-ae63-9075bf37").should be_nil
        end

        it "returns nil for nil" do
          typecaster.call(nil).should be_nil
        end
      end
    end
  end
end
