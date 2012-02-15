require "spec_helper"
require "active_attr/model"
require "active_support/core_ext/hash/conversions"
require "active_support/json/decoding"

module ActiveAttr
  describe Model do
    let :model_class do
      Class.new do
        include Model

        attribute :first_name
        attribute :last_name
        attribute :age, :type => Integer

        attr_protected :last_name

        def self.name
          "Person"
        end
      end
    end

    subject { model_class.new }
    it_should_behave_like "ActiveModel"

    it "reads and writes attributes" do
      subject.first_name = "Chris"
      subject.first_name.should eq "Chris"
      subject.attributes["first_name"].should == "Chris"
    end

    it "can query attributes" do
      subject.first_name?.should be_false
      subject.first_name = "Chris"
      subject.first_name?.should be_true
    end

    it "initializes with a block that can use attributes" do
      model_class.new do |person|
        person.write_attribute :first_name, "Chris"
      end.read_attribute(:first_name).should == "Chris"
    end

    it "processes mass assignment before yielding to an initialization block" do
      model_class.new(:first_name => "Chris") do |person|
        person.first_name.should == "Chris"
      end
    end

    it "has a logger" do
      logger = double("logger")
      model_class.logger?.should be_false
      subject.logger?.should be_false

      model_class.logger = logger

      model_class.logger?.should be_true
      model_class.logger.should eq logger
      subject.logger?.should be_true
      subject.logger.should == logger
    end

    it "supports mass assignment with security" do
      person = model_class.new(:first_name => "Chris", :last_name => "Griego")
      person.first_name.should eq "Chris"
      person.last_name.should be_nil
    end

    it "does not use strict mass assignment" do
      expect { subject.assign_attributes :middle_initial => "J" }.not_to raise_error
    end

    it "serializes to/from JSON" do
      subject.first_name = "Chris"
      model_class.new.from_json(subject.to_json).first_name.should == "Chris"
    end

    it "serializes to/from XML" do
      subject.first_name = "Chris"
      model_class.new.from_xml(subject.to_xml).first_name.should == "Chris"
    end

    it "supports attribute name translation" do
      model_class.human_attribute_name(:first_name).should == "First name"
    end

    it "typecasts attributes" do
      subject.age = "29"
      subject.age.should eql 29
    end

    context "attribute defaults" do
      let :model_class do
        Class.new do
          include Model

          attribute :start_date
          attribute :end_date, :default => lambda { start_date }
          attribute :age_limit, :default => 21
        end
      end

      it "are applied" do
        subject.age_limit.should == 21
      end

      it "are overridden by mass assigned attributes" do
        model_class.new(:age_limit => 18).age_limit.should == 18
      end

      it "can access mass assigned attributes" do
        model_class.new(:start_date => Date.today).end_date.should == Date.today
      end

      it "can access attributes assigned in the initialization block" do
        model_class.new do |event|
          event.start_date = Date.today
        end.end_date.should == Date.today
      end
    end
  end
end
