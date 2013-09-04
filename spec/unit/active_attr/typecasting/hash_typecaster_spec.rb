require "spec_helper"
require "active_attr/typecasting/hash_typecaster"
require "active_support/basic_object"

module ActiveAttr
  module Typecasting
    describe HashTypecaster do
      describe "#call" do
        it "returns hashes" do
          value = { 'foo' => 'bar' }
          subject.call(value).should eql value
        end

        it "parses json for a String" do
          value = { 'foo' => 'bar' }
          subject.call(value.to_json).should eql value
        end

        it "casts nil to an empty Hash" do
          subject.call(nil).should eql Hash.new
        end

        it "casts invalid object types to an empty Hash" do
          subject.call([]).should eql Hash.new
        end
      end
    end
  end
end
