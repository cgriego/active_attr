require "spec_helper"
require "active_attr/attribute_defaults"

module ActiveAttr
  describe AttributeDefaults do
    subject(:model) { model_class.new }

    let :model_class do
      Class.new do
        include InitializationVerifier
        include AttributeDefaults
        attribute :first_name, :default => "John"
        attribute :age, :default => nil
        attribute :created_at, :default => lambda { Time.now }
      end
    end

    describe "#attribute_defaults" do
      subject(:attribute_defaults) { model_class.new.attribute_defaults }

      it { is_expected.to be_a_kind_of Hash }

      it "includes declared literal string attribute defaults" do
        expect(attribute_defaults["first_name"]).to eq("John")
      end

      it "includes declared nil attribute defaults" do
        expect(attribute_defaults).to include "age"
        expect(attribute_defaults["age"]).to be_nil
      end

      it "includes declared dynamic attribute defaults" do
        expect(attribute_defaults["created_at"]).to be_a_kind_of Time
      end
    end

    describe "#initialize" do
      it "invokes the superclass initializer" do
        is_expected.to be_initialized
      end
    end
  end
end
