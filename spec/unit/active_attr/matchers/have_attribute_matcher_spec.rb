require "spec_helper"
require "active_attr/attributes"
require "active_attr/matchers/have_attribute_matcher"

module ActiveAttr
  describe Matchers do
    let(:dsl) { Object.new.extend described_class }
    subject { dsl }

    it { should respond_to(:have_attribute).with(1).argument }

    describe "#have_attribute" do
      subject { dsl.have_attribute(:first_name) }

      it "builds a HaveAttributeMatcher" do
        should be_a_kind_of Matchers::HaveAttributeMatcher
      end

      it "uses the given attribute name to construct the matcher" do
        subject.send(:attribute_name).should == :first_name
      end
    end
  end

  module Matchers
    describe HaveAttributeMatcher do
      let :model_class do
        Class.new do
          include Attributes
          attribute :first_name, :default => "John"
          attribute :last_name
          attribute :admin, :default => false

          def self.to_s
            "Person"
          end
        end
      end

      subject { positive_matcher }
      let(:positive_matcher) { described_class.new(:first_name) }
      let(:negative_matcher) { described_class.new(:age) }
      let(:positive_matcher_with_default) { described_class.new(:first_name).with_default_value_of("John") }
      let(:positive_matcher_with_false_default) { described_class.new(:admin).with_default_value_of(false) }
      let(:negative_matcher_with_wrong_default) { described_class.new(:first_name).with_default_value_of("Doe") }
      let(:negative_matcher_with_default_no_attribute) { described_class.new(:age).with_default_value_of(21) }
      let(:negative_matcher_with_nil_default) { described_class.new(:first_name).with_default_value_of(nil) }

      it { described_class.should respond_to(:new).with(1).argument }

      describe "#description" do
        it "returns a description appropriate to the expectation" do
          subject.description.should == "have attribute named first_name"
        end

        it "mentions the default value if set" do
          positive_matcher_with_default.description.should == %{have attribute named first_name with a default value of "John"}
        end

        it "mentions the default value if set to false" do
          positive_matcher_with_false_default.description.should == %{have attribute named admin with a default value of false}
        end
      end

      describe "#failure_message" do
        it "returns a failure message appropriate to the expectation and subject" do
          negative_matcher.tap do |matcher|
            matcher.matches? model_class
          end.failure_message.should == "Expected Person to have attribute named age"
        end

        it "mentions the default value if set" do
          negative_matcher_with_wrong_default.tap do |matcher|
            matcher.matches? model_class
          end.failure_message.should == %{Expected Person to have attribute named first_name with a default value of "Doe"}
        end

        it "mentions the default value if set to false" do
          negative_matcher_with_nil_default.tap do |matcher|
            matcher.matches? model_class
          end.failure_message.should == %{Expected Person to have attribute named first_name with a default value of nil}
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

        context "when the matcher specifies a default value" do
          it "is true with an instance of a model class that has the attribute with the default value" do
            positive_matcher_with_default.matches?(model_class).should be_true
          end

          it "is true with a model class that has the attribute with the default value" do
            positive_matcher_with_default.matches?(model_class).should be_true
          end

          it "is false with an instance of a model class that does not have the attribute" do
            negative_matcher_with_default_no_attribute.matches?(model_instance).should be_false
          end

          it "is false with a model class that does not have the attribute" do
            negative_matcher_with_default_no_attribute.matches?(model_class).should be_false
          end

          it "is false with an instance of a model class that has the attribute but not with the specified default value" do
            negative_matcher_with_wrong_default.matches?(model_instance).should be_false
          end

          it "is false with a model class that has the attribute but not with the specified default value" do
            negative_matcher_with_wrong_default.matches?(model_class).should be_false
          end

          it "is true with an instance of a model class that has the attribute with the default value of false" do
            positive_matcher_with_false_default.matches?(model_class).should be_true
          end

          it "is true with a model class that has the attribute with the default value where the default value is false" do
            positive_matcher_with_false_default.matches?(model_class).should be_true
          end

          it "is true with an instance of a model class that has the attribute with the default value where the default value is false" do
            positive_matcher_with_false_default.matches?(model_class).should be_true
          end

          it "is true with a model class that has the attribute with the default value false" do
            positive_matcher_with_false_default.matches?(model_class).should be_true
          end

          it "is false with an instance of a model class that has the attribute but not with the specified default value where the specified default value is nil" do
            negative_matcher_with_nil_default.matches?(model_instance).should be_false
          end

          it "is false with a model class that has the attribute but not with the specified default value where the specified default value is nil" do
            negative_matcher_with_nil_default.matches?(model_class).should be_false
          end
        end
      end

      describe "#negative_failure_message" do
        it "returns a failure message appropriate to the expectation and subject" do
          positive_matcher.tap do |matcher|
            matcher.matches? model_class
          end.negative_failure_message.should == "Expected Person to not have attribute named first_name"
        end

        it "mentions the default value if set" do
          positive_matcher_with_default.tap do |matcher|
            matcher.matches? model_class
          end.negative_failure_message.should == %{Expected Person to not have attribute named first_name with a default value of "John"}
        end

        it "mentions the default value if set to false" do
          positive_matcher_with_false_default.tap do |matcher|
            matcher.matches? model_class
          end.negative_failure_message.should == %{Expected Person to not have attribute named admin with a default value of false}
        end
      end
    end
  end
end
