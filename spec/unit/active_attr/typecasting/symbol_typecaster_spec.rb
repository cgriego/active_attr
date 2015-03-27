require "spec_helper"
require "active_attr/typecasting/symbol_typecaster"

module ActiveAttr
  module Typecasting
    describe SymbolTypecaster do
      subject(:typecaster) { described_class.new }

      describe "#call" do
        it "returns the original symbol for a Symbol" do
          value = :value
          typecaster.call(value).should eql value
        end

        it "casts nil to an nil" do
          typecaster.call(nil).should eql nil
        end

        it "returns the Symbol version of a String" do
          typecaster.call('value').should eql :value
        end
      end
    end
  end
end
