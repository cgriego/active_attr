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
      model.first_name.should eq "Chris"
      model.attributes["first_name"].should == "Chris"
    end

    it "can query attributes" do
      model.first_name?.should eq false
      model.first_name = "Chris"
      model.first_name?.should == true
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
      model_class.logger?.should eq false
      model.logger?.should eq false

      model_class.logger = logger

      model_class.logger?.should eq true
      model_class.logger.should eq logger
      model.logger?.should eq true
      model.logger.should == logger
    end

    it "supports mass assignment with security" do
      person = model_class.new(:first_name => "Chris", :last_name => "Griego")
      person.first_name.should eq "Chris"
      person.last_name.should be_nil
    end

    it "does not use strict mass assignment" do
      expect { model.assign_attributes :middle_initial => "J" }.not_to raise_error
    end

    it "serializes to/from JSON" do
      model.first_name = "Chris"
      model_class.new.from_json(model.to_json).first_name.should == "Chris"
    end

    it "supports attribute name translation" do
      model_class.human_attribute_name(:first_name).should == "First name"
    end

    it "typecasts attributes" do
      model.age = "29"
      model.age.should eql 29
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
        model.age_limit.should == 21
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

    context "when define validation callbacks" do
      let :model_class do
        Class.new do
          include Model

          attribute :name
          attribute :status

          validates :name, :presence => true, :length => {:maximum => 6}

          before_validation :remove_whitespaces
          after_validation :set_status

          def self.name
            "Person"
          end

          private

          def remove_whitespaces
            name.strip!
          end

          def set_status
            self.status = errors.empty?
          end
        end
      end

      it "can call before_validation" do
        person = model_class.new(:name => "  bob  ")

        expect(person.valid?).to be(true)
        expect(person.name).to eq("bob")
      end

      it "can call after_validation" do
        person = model_class.new(:name => "")
        expect(person.valid?).to be(false)
        expect(person.status).to be(false)

        person = model_class.new(:name => "alice")
        expect(person.valid?).to be(true)
        expect(person.status).to be(true)
      end
    end
  end
end
