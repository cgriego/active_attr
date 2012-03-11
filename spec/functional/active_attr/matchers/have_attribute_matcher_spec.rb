require "spec_helper"
require "active_attr/attributes"
require "active_attr/attribute_defaults"
require "active_attr/matchers/have_attribute_matcher"
require "active_attr/typecasted_attributes"

module ActiveAttr
  module Matchers
    describe HaveAttributeMatcher do
      let :model_class do
        Class.new do
          include Attributes
          include AttributeDefaults
          include TypecastedAttributes

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

      shared_examples "a matcher matching a class without ActiveAttr::TypecastedAttributes" do
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

          it { subject.failure_message.should == %{expected #{model_class.name} to include ActiveAttr::TypecastedAttributes} }
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

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named first_name} }
          end
        end

        context "a class without the attribute" do
          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{expected Person to have attribute named first_name} }
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

            it { subject.failure_message.should == %{expected Person to have attribute named first_name with a default value of "John"} }
          end
        end

        context "a class with the attribute and a different default" do
          before { model_class.attribute :first_name, :default => "Doe" }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{expected Person to have attribute named first_name with a default value of "John"} }
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :first_name, :default => "John" }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named first_name with a default value of "John"} }
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

            it { subject.failure_message.should == %{expected Person to have attribute named admin with a default value of false} }
          end
        end

        context "a class with the attribute and a default of nil" do
          before { model_class.attribute :admin, :default => nil }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{expected Person to have attribute named admin with a default value of false} }
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :admin, :default => false }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named admin with a default value of false} }
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

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named first_name with a default value of nil} }
          end
        end

        context "a class with the attribute and a default of false" do
          before { model_class.attribute :first_name, :default => false }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{expected Person to have attribute named first_name with a default value of nil} }
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :first_name, :default => nil }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named first_name with a default value of nil} }
          end
        end
      end

      context "a matcher with a type" do
        subject { described_class.new(:first_name).of_type(String) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::TypecastedAttributes"

        context "a class with the attribute but no type" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{expected Person to have attribute named first_name of type String} }
          end
        end

        context "a class with the attribute and a different type" do
          before { model_class.attribute :first_name, :type => Symbol }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{expected Person to have attribute named first_name of type String} }
          end
        end

        context "a class with the attribute and the right type" do
          before { model_class.attribute :first_name, :type => String }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named first_name of type String} }
          end
        end
      end

      context "a matcher with a type of Object" do
        subject { described_class.new(:first_name).of_type(Object) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::TypecastedAttributes"

        context "a class with the attribute but no type" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named first_name of type Object} }
          end
        end

        context "a class with the attribute and a different type" do
          before { model_class.attribute :first_name, :type => String }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_false }
          end

          describe "#failure_message" do
            before { subject.matches?(model_class) }

            it { subject.failure_message.should == %{expected Person to have attribute named first_name of type Object} }
          end
        end

        context "a class with the attribute and the right type" do
          before { model_class.attribute :first_name, :type => Object }

          describe "#matches?" do
            it { subject.matches?(model_class).should be_true }
          end

          describe "#negative_failure_message" do
            before { subject.matches?(model_class) }

            it { subject.negative_failure_message.should == %{expected Person to not have attribute named first_name of type Object} }
          end
        end
      end
    end
  end
end
