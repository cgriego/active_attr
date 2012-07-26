require "spec_helper"
require "active_attr/attribute_defaults"

module ActiveAttr
  describe AttributeDefaults do
    subject { model_class.new }

    let :model_class do
      Class.new do
        include Model
        attribute :first_name, :type => String, :default => "John"
        attribute :age, :type => Integer, :default => nil
        attribute :friends, :type => Array, :default => []
      end
    end

    it "should have the right defaults" do
      subject.first_name.should == 'John'
      subject.age.should be_nil
      subject.friends.should == []
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
        subject["friends"].should == []
      end
    end

  end
end
