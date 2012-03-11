require "spec_helper"
require "active_attr/attributes"
require "active_attr/attribute_defaults"
require "active_attr/matchers/have_attribute_matcher"

module ActiveAttr
  module Matchers
    describe HaveAttributeMatcher do
      let :model_class do
        Class.new do
          include Attributes
          include AttributeDefaults

          def self.name
            "Person"
          end
        end
      end

      shared_examples "a matcher matching a class without ActiveAttr::Attributes" do
        let :model_class do
          Class.new do
            def self.name
              "Person"
            end
          end
        end

        describe "#matches?" do
          it { subject.matches?(model_class).should be_false }
        end

        describe "#failure_message" do
          before { subject.matches?(model_class) }

          it { subject.failure_message.should == %{expected #{model_class.name} to include ActiveAttr::Attributes} }
        end
      end

      shared_examples "a matcher matching a class without ActiveAttr::AttributeDefaults" do
        let :model_class do
          Class.new do
            include Attributes

            def self.name
              "Person"
            end
          end
        end

        describe "#matches?" do
          it { subject.matches?(model_class).should be_false }
        end

        describe "#failure_message" do
          before { subject.matches?(model_class) }

          it { subject.failure_message.should == %{expected #{model_class.name} to include ActiveAttr::AttributeDefaults} }
        end
      end

      context "a matcher with just an attribute name" do
        subject { described_class.new(:first_name) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"

        context "a class with the attribute" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{Expected Person to not have attribute named first_name} }
          end
        end

        context "a class without the attribute" do
          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{Expected Person to have attribute named first_name} }
          end
        end
      end

      context "a matcher with a default value" do
        subject { described_class.new(:first_name).with_default_value_of("John") }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::AttributeDefaults"

        context "a class with the attribute but no default" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{Expected Person to have attribute named first_name with a default value of "John"} }
          end
        end

        context "a class with the attribute and a different default" do
          before { model_class.attribute :first_name, :default => "Doe" }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{Expected Person to have attribute named first_name with a default value of "John"} }
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :first_name, :default => "John" }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{Expected Person to not have attribute named first_name with a default value of "John"} }
          end
        end
      end

      context "a matcher with a default value of false" do
        subject { described_class.new(:admin).with_default_value_of(false) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::AttributeDefaults"

        context "a class with the attribute but no default" do
          before { model_class.attribute :admin }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{Expected Person to have attribute named admin with a default value of false} }
          end
        end

        context "a class with the attribute and a default of nil" do
          before { model_class.attribute :admin, :default => nil }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{Expected Person to have attribute named admin with a default value of false} }
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :admin, :default => false }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{Expected Person to not have attribute named admin with a default value of false} }
          end
        end
      end

      context "a matcher with a default value of nil" do
        subject { described_class.new(:first_name).with_default_value_of(nil) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::AttributeDefaults"

        context "a class with the attribute but no default" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{Expected Person to not have attribute named first_name with a default value of nil} }
          end
        end

        context "a class with the attribute and a default of false" do
          before { model_class.attribute :first_name, :default => false }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{Expected Person to have attribute named first_name with a default value of nil} }
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :first_name, :default => nil }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{Expected Person to not have attribute named first_name with a default value of nil} }
          end
        end
      end
    end
  end
end
