require "spec_helper"
require "active_attr/attribute_defaults"

module ActiveAttr
  describe AttributeDefaults do
    subject(:model) { model_class.new }
    let(:non_duplicable) { double("non-duplicable", :duplicable? => false) }

    let :model_class do
      non_duplicable_default = non_duplicable

      Class.new do
        include InitializationVerifier
        include AttributeDefaults
        attribute :first_name, :default => "John"
        attribute :age, :default => nil
        attribute :created_at, :default => lambda { Time.now }
        attribute :non_duplicable, :default => non_duplicable_default
      end
    end

    describe "#attribute_defaults" do
      subject(:attribute_defaults) { model_class.new.attribute_defaults }

      it { should be_a_kind_of Hash }

      it "includes declared literal string attribute defaults" do
        attribute_defaults["first_name"].should == "John"
      end

      it "includes declared nil attribute defaults" do
        attribute_defaults.should include "age"
        attribute_defaults["age"].should be_nil
      end

      it "includes declared dynamic attribute defaults" do
        attribute_defaults["created_at"].should be_a_kind_of Time
      end

      it "includes non-duplicable attribute defaults" do
        attribute_defaults["non_duplicable"].should == non_duplicable
      end
    end

    describe "#initialize" do
      it "invokes the superclass initializer" do
        should be_initialized
      end
    end

    describe "#freeze" do
      context "when frozen before defaults are applied" do
        subject(:frozen_model) do
          model_class.new.tap do |m|
            m.instance_variable_set(:@attributes, {})
            m.freeze
          end
        end

        it "raises when apply_defaults is called with missing keys" do
          expect { frozen_model.apply_defaults }.to raise_error(frozen_error_class)
        end
      end

      context "when frozen after initialization (defaults already applied)" do
        before { model.freeze }

        it "does not raise when apply_defaults is called" do
          expect { model.apply_defaults }.not_to raise_error
        end
      end
    end
  end
end
