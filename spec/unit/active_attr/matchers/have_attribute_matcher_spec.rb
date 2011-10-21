require "spec_helper"
require "active_attr/attributes"
require "active_attr/matchers/have_attribute_matcher"

module ActiveAttr
  describe Matchers do
    let(:dsl) { Object.new.extend described_class }
    subject { dsl }

    it { should respond_to(:have_attribute).with(1).argument }

    describe "#have_attribute" do
      subject { dsl.have_attribute(:name) }

      it "builds a HaveAttributeMatcher with the given attribute name" do
        should be_a_kind_of Matchers::HaveAttributeMatcher
      end

      it "uses the given attribute name to construct the matcher" do
        subject.attribute_name.should == :name
      end
    end
  end

  module Matchers
    describe HaveAttributeMatcher do
      let :model_class do
        Class.new do
          include Attributes
          attribute :name

          def self.to_s
            "Person"
          end
        end
      end

      subject { positive_matcher }
      let(:positive_matcher) { described_class.new(:name) }
      let(:negative_matcher) { described_class.new(:age) }

      it { described_class.should respond_to(:new).with(1).argument }

      describe "#attribute_name" do
        it "returns the value used to initialize the matcher" do
          subject.attribute_name.should == :name
        end

        it "converts the value used to initialize the matcher to a symbol" do
          described_class.new('name').attribute_name.should == :name
        end
      end

      describe "#description" do
        it "returns a description appropriate to the expectation" do
          subject.description.should == "have attribute named name"
        end
      end

      describe "#failure_message" do
        it "returns a failure message appropriate to the expectation and subject" do
          negative_matcher.tap do |matcher|
            matcher.matches? model_class
          end.failure_message.should == "Expected Person to have attribute named age"
        end
      end

      describe "#initialize" do
        it "raises a TypeError when the attribute name does not respond to #to_sym" do
          expect { described_class.new(Object.new) }.to raise_error(TypeError, "can't convert Object into Symbol")
        end
      end

      describe "#matches?" do
        let(:model_instance) { model_class.new }

        it "is true with an instance of a model class that has the attribute" do
          positive_matcher.matches?(model_instance).should be_true
        end

        it "is true with a model class that has the attribute" do
          positive_matcher.matches?(model_class).should be_true
        end

        it "is false with an instance of a model class that does not have the attribute" do
          negative_matcher.matches?(model_instance).should be_false
        end

        it "is false with a model class that does not have the attribute" do
          negative_matcher.matches?(model_class).should be_false
        end
      end

      describe "#negative_failure_message" do
        it "returns a failure message appropriate to the expectation and subject" do
          positive_matcher.tap do |matcher|
            matcher.matches? model_class
          end.negative_failure_message.should == "Expected Person to not have attribute named name"
        end
      end
    end
  end
end
