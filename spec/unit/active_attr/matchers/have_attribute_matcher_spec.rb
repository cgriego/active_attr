require "spec_helper"
require "active_attr/matchers/have_attribute_matcher"

module ActiveAttr
  module Matchers
    describe HaveAttributeMatcher do
      describe ".class" do
        it { expect(described_class).to respond_to(:new).with(1).argument }
      end

      describe "#description" do
        it "returns a description appropriate to the expectation" do
          expect(described_class.new(:first_name).description).to eq("have attribute named first_name")
        end

        it "mentions the default value if set" do
          expect(described_class.new(:first_name).with_default_value_of("John").description).to eq(%{have attribute named first_name with a default value of "John"})
        end

        it "mentions the default value if set to nil" do
          expect(described_class.new(:first_name).with_default_value_of(nil).description).to eq(%{have attribute named first_name with a default value of nil})
        end

        it "mentions the default value if set to false" do
          expect(described_class.new(:admin).with_default_value_of(false).description).to eq(%{have attribute named admin with a default value of false})
        end

        it "mentions the type if set" do
          expect(described_class.new(:first_name).of_type(String).description).to eq(%{have attribute named first_name of type String})
        end

        it "mentions both the type and default if both are set" do
          description = described_class.new(:first_name).of_type(String).with_default_value_of("John").description
          expect(description).to eq(%{have attribute named first_name of type String with a default value of "John"})
        end
      end

      describe "#initialize" do
        it "raises a TypeError when the attribute name does not respond to #to_sym" do
          expect { described_class.new(Object.new) }.to raise_error(TypeError, "can't convert Object into Symbol")
        end
      end

      describe "#of_type" do
        it "chains" do
          expect(described_class.new(:first_name).of_type(String)).to be_a_kind_of described_class
        end
      end

      describe "#with_default_value_of" do
        it "chains" do
          expect(described_class.new(:first_name).with_default_value_of(nil)).to be_a_kind_of described_class
        end
      end
    end
  end
end
