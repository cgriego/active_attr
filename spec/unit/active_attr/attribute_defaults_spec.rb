require "spec_helper"
require "active_attr/attribute_defaults"

module ActiveAttr
  describe AttributeDefaults do
    subject { model_class.new }

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
      subject { model_class.new.attribute_defaults }

      it { should be_a_kind_of Hash }

      it "includes declared literal string attribute defaults" do
        subject["first_name"].should == "John"
      end

      it "includes declared nil attribute defaults" do
        subject.should include "age"
        subject["age"].should be_nil
      end

      it "includes declared dynamic attribute defaults" do
        subject["created_at"].should be_a_kind_of Time
      end
    end

    describe "#initialize" do
      it "invokes the superclass initializer" do
        should be_initialized
      end
    end
  end
end
