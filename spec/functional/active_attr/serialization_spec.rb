require "spec_helper"
require "active_attr/serialization"
require "active_support/core_ext/hash/conversions"
require "active_support/json/decoding"

module ActiveAttr
  describe Serialization do
    let :model_class do
      Class.new do
        include Serialization
        attribute :first_name

        def self.name
          "Person"
        end
      end
    end

    subject { model_class.new }

    it "serializes to/from JSON" do
      subject.first_name = "Chris"
      model_class.new.from_json(subject.to_json).first_name.should == "Chris"
    end

    it "serializes to/from XML" do
      subject.first_name = "Chris"
      model_class.new.from_xml(subject.to_xml).first_name.should == "Chris"
    end
  end
end
