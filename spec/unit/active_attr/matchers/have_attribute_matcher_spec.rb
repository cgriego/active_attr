require "spec_helper"
require "active_attr/matchers/have_attribute_matcher"

module ActiveAttr
  module Matchers
    describe HaveAttributeMatcher do
      describe ".class" do
        it { described_class.should respond_to(:new).with(1).argument }
      end

      describe "#description" do
        it "returns a description appropriate to the expectation" do
          described_class.new(:first_name).description.should == "have attribute named first_name"
        end

        it "mentions the default value if set" do
          described_class.new(:first_name).with_default_value_of("John").description.should == %{have attribute named first_name with a default value of "John"}
        end

        it "mentions the default value if set to false" do
          described_class.new(:admin).with_default_value_of(false).description.should == %{have attribute named admin with a default value of false}
        end
      end

      describe "#initialize" do
        it "raises a TypeError when the attribute name does not respond to #to_sym" do
          expect { described_class.new(Object.new) }.to raise_error(TypeError, "can't convert Object into Symbol")
        end
      end
    end
  end
end
