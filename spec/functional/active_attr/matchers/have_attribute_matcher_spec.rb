require "spec_helper"
require "active_attr/attributes"
require "active_attr/attribute_defaults"
require "active_attr/matchers/have_attribute_matcher"
require "active_attr/typecasted_attributes"
require "active_support/core_ext/string/strip"

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
          it { matcher.matches?(model_class).should == false }
        end

        describe "#failure_message" do
          before { matcher.matches?(model_class) }

          it { matcher.failure_message.should == %{expected #{model_class.name} to include ActiveAttr::Attributes} }
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
          it { matcher.matches?(model_class).should == false }
        end

        describe "#failure_message" do
          before { matcher.matches?(model_class) }

          it { matcher.failure_message.should == %{expected #{model_class.name} to include ActiveAttr::AttributeDefaults} }
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
          it { matcher.matches?(model_class).should == false }
        end

        describe "#failure_message" do
          before { matcher.matches?(model_class) }

          it { matcher.failure_message.should == %{expected #{model_class.name} to include ActiveAttr::TypecastedAttributes} }
        end
      end

      context "a matcher with just an attribute name" do
        subject(:matcher) { described_class.new(:first_name) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"

        context "a class with the attribute" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :first_name
                           got: attribute :first_name
                MESSAGE
              end
            end
          end
        end

        context "a class without the attribute" do
          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it { matcher.failure_message.should == %{expected Person to have attribute named first_name} }
          end
        end
      end

      context "a matcher with a default value" do
        subject(:matcher) { described_class.new(:first_name).with_default_value_of("John") }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::AttributeDefaults"

        context "a class with the attribute but no default" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :first_name, :default => "John"
                     got: attribute :first_name
              MESSAGE
            end
          end
        end

        context "a class with the attribute and a different default" do
          before { model_class.attribute :first_name, :default => "Doe" }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :first_name, :default => "John"
                     got: attribute :first_name, :default => "Doe"
              MESSAGE
            end
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :first_name, :default => "John" }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :first_name, :default => "John"
                           got: attribute :first_name, :default => "John"
                MESSAGE
              end
            end
          end
        end
      end

      context "a matcher with a default value of false" do
        subject(:matcher) { described_class.new(:admin).with_default_value_of(false) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::AttributeDefaults"

        context "a class with the attribute but no default" do
          before { model_class.attribute :admin }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :admin, :default => false
                     got: attribute :admin
              MESSAGE
            end
          end
        end

        context "a class with the attribute and a default of nil" do
          before { model_class.attribute :admin, :default => nil }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :admin, :default => false
                     got: attribute :admin, :default => nil
              MESSAGE
            end
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :admin, :default => false }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :admin, :default => false
                           got: attribute :admin, :default => false
                MESSAGE
              end
            end
          end
        end
      end

      context "a matcher with a default value of nil" do
        subject(:matcher) { described_class.new(:first_name).with_default_value_of(nil) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::AttributeDefaults"

        context "a class with the attribute but no default" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :first_name, :default => nil
                           got: attribute :first_name
                MESSAGE
              end
            end
          end
        end

        context "a class with the attribute and a default of false" do
          before { model_class.attribute :first_name, :default => false }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :first_name, :default => nil
                     got: attribute :first_name, :default => false
              MESSAGE
            end
          end
        end

        context "a class with the attribute and the right default" do
          before { model_class.attribute :first_name, :default => nil }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :first_name, :default => nil
                           got: attribute :first_name, :default => nil
                MESSAGE
              end
            end
          end
        end
      end

      context "a matcher with a type" do
        subject(:matcher) { described_class.new(:first_name).of_type(String) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::TypecastedAttributes"

        context "a class with the attribute but no type" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :first_name, :type => String
                     got: attribute :first_name
              MESSAGE
            end
          end
        end

        context "a class with the attribute and a different type" do
          before { model_class.attribute :first_name, :type => Symbol }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :first_name, :type => String
                     got: attribute :first_name, :type => Symbol
              MESSAGE
            end
          end
        end

        context "a class with the attribute and the right type" do
          before { model_class.attribute :first_name, :type => String }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :first_name, :type => String
                           got: attribute :first_name, :type => String
                MESSAGE
              end
            end
          end
        end
      end

      context "a matcher with a type of Object" do
        subject(:matcher) { described_class.new(:first_name).of_type(Object) }

        it_should_behave_like "a matcher matching a class without ActiveAttr::Attributes"
        it_should_behave_like "a matcher matching a class without ActiveAttr::TypecastedAttributes"

        context "a class with the attribute but no type" do
          before { model_class.attribute :first_name }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :first_name, :type => Object
                           got: attribute :first_name
                MESSAGE
              end
            end
          end
        end

        context "a class with the attribute and a different type" do
          before { model_class.attribute :first_name, :type => String }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == false }
          end

          describe "#failure_message" do
            before { matcher.matches?(model_class) }

            it do
              matcher.failure_message.should == <<-MESSAGE.strip_heredoc.chomp
                expected: attribute :first_name, :type => Object
                     got: attribute :first_name, :type => String
              MESSAGE
            end
          end
        end

        context "a class with the attribute and the right type" do
          before { model_class.attribute :first_name, :type => Object }

          describe "#matches?" do
            it { matcher.matches?(model_class).should == true }
          end

          [:negative_failure_message, :failure_message_when_negated].each do |method|
            describe "##{method}" do
              before { matcher.matches?(model_class) }

              it do
                matcher.send(method).should == <<-MESSAGE.strip_heredoc.chomp
                  expected not: attribute :first_name, :type => Object
                           got: attribute :first_name, :type => Object
                MESSAGE
              end
            end
          end
        end
      end
    end
  end
end
