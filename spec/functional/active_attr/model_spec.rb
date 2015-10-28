require "spec_helper"
require "active_attr/model"
require "active_model/mass_assignment_security"
require "active_support/core_ext/hash/conversions"
require "active_support/json/decoding"

module ActiveAttr
  describe Model do
    let :model_class do
      Class.new do
        include Model
        include ActiveModel::MassAssignmentSecurity

        attribute :first_name
        attribute :last_name
        attribute :age, :type => Integer

        attr_protected :last_name

        def self.name
          "Person"
        end
      end
    end

    subject(:model) { model_class.new }

    it_should_behave_like "ActiveModel" do
      subject { model_class.new }
    end

    it "reads and writes attributes" do
      model.first_name = "Chris"
      expect(model.first_name).to eq "Chris"
      expect(model.attributes["first_name"]).to eq("Chris")
    end

    it "can query attributes" do
      expect(model.first_name?).to eq false
      model.first_name = "Chris"
      expect(model.first_name?).to eq(true)
    end

    it "initializes with a block that can use attributes" do
      expect(model_class.new do |person|
        person.write_attribute :first_name, "Chris"
      end.read_attribute(:first_name)).to eq("Chris")
    end

    it "processes mass assignment before yielding to an initialization block" do
      model_class.new(:first_name => "Chris") do |person|
        expect(person.first_name).to eq("Chris")
      end
    end

    it "has a logger" do
      logger = double("logger")
      expect(model_class.logger?).to eq false
      expect(model.logger?).to eq false

      model_class.logger = logger

      expect(model_class.logger?).to eq true
      expect(model_class.logger).to eq logger
      expect(model.logger?).to eq true
      expect(model.logger).to eq(logger)
    end

    it "supports mass assignment with security" do
      person = model_class.new(:first_name => "Chris", :last_name => "Griego")
      expect(person.first_name).to eq "Chris"
      expect(person.last_name).to be_nil
    end

    it "does not use strict mass assignment" do
      expect { model.assign_attributes :middle_initial => "J" }.not_to raise_error
    end

    it "serializes to/from JSON" do
      model.first_name = "Chris"
      expect(model_class.new.from_json(model.to_json).first_name).to eq("Chris")
    end

    it "serializes to/from XML" do
      model.first_name = "Chris"
      model.last_name = "Griego"
      model.age = 21
      expect(model_class.new.from_xml(model.to_xml).first_name).to eq("Chris")
    end

    it "supports attribute name translation" do
      expect(model_class.human_attribute_name(:first_name)).to eq("First name")
    end

    it "typecasts attributes" do
      model.age = "29"
      expect(model.age).to eql 29
    end

    context "attribute defaults" do
      let :model_class do
        Class.new do
          include Model
          include ActiveModel::MassAssignmentSecurity

          attribute :start_date
          attribute :end_date, :default => lambda { start_date }
          attribute :age_limit, :default => 21
        end
      end

      it "are applied" do
        expect(model.age_limit).to eq(21)
      end

      it "are overridden by mass assigned attributes" do
        expect(model_class.new(:age_limit => 18).age_limit).to eq(18)
      end

      it "can access mass assigned attributes" do
        expect(model_class.new(:start_date => Date.today).end_date).to eq(Date.today)
      end

      it "can access attributes assigned in the initialization block" do
        expect(model_class.new do |event|
          event.start_date = Date.today
        end.end_date).to eq(Date.today)
      end
    end
  end
end
