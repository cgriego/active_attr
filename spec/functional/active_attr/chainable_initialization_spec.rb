require "spec_helper"
require "active_attr/chainable_initialization"
require "active_support/concern"

module ActiveAttr
  describe ChainableInitialization do
    subject { model_class.new("arg") }

    shared_examples "chained initialization" do
      describe "#initialize" do
        it { expect { subject }.not_to raise_error }
        it { subject.initialized?.should be_true }
      end
    end

    context "mixed into a class with an argument to initialize" do
      let :model_class do
        Class.new do
          include InitializationVerifier
          include ChainableInitialization

          def initialize(arg)
            super
          end
        end
      end

      include_examples "chained initialization"
    end

    context "mixed into a subclass with an argument to initialize on the superclass" do
      context "subclassing a model" do
        let :parent_class do
          Class.new do
            include InitializationVerifier

            def initialize(arg)
              super
            end
          end
        end

        let :model_class do
          Class.new(parent_class) do
            include ChainableInitialization

            def initialize(arg)
              super
            end
          end
        end

        include_examples "chained initialization"
      end
    end

    context "mixed into a concern which is mixed into a class with an argument to initialize" do
      let :model_class do
        Class.new do
          include InitializationVerifier

          include Module.new {
            extend ActiveSupport::Concern
            include ChainableInitialization
          }

          def initialize(arg)
            super
          end
        end
      end

      include_examples "chained initialization"
    end

    if defined?(BasicObject)
      context "mixed into a class that inherits from BasicObject with an argument to initialize" do
        let :model_class do
          Class.new(BasicObject) do
            include InitializationVerifier
            include ChainableInitialization

            def initialize(arg)
              super
            end
          end
        end

        include_examples "chained initialization"
      end
    end
  end
end
