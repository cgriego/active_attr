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
          described_class.new(:first_name).description.should == "has attribute named first_name"
        end

        it "mentions the default value if set" do
          described_class.new(:first_name).with_default_value_of("John").description.should == %{has attribute named first_name with a default value of "John"}
        end

        it "mentions the default value if set to nil" do
          described_class.new(:first_name).with_default_value_of(nil).description.should == %{has attribute named first_name with a default value of nil}
        end

        it "mentions the default value if set to false" do
          described_class.new(:admin).with_default_value_of(false).description.should == %{has attribute named admin with a default value of false}
        end

        it "mentions the type if set" do
          described_class.new(:first_name).of_type(String).description.should == %{has attribute named first_name of type String}
        end

        it "mentions both the type and default if both are set" do
          description = described_class.new(:first_name).of_type(String).with_default_value_of("John").description
          description.should == %{has attribute named first_name of type String with a default value of "John"}
        end
      end

      describe "#initialize" do
        it "raises a TypeError when the attribute name does not respond to #to_sym" do
          expect { described_class.new(Object.new) }.to raise_error(TypeError, "can't convert Object into Symbol")
        end
      end

      describe "#of_type" do
        it "chains" do
          described_class.new(:first_name).of_type(String).should be_a_kind_of described_class
        end
      end

      describe "#with_default_value_of" do
        it "chains" do
          described_class.new(:first_name).with_default_value_of(nil).should be_a_kind_of described_class
        end
      end
    end
  end
end
