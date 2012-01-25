require "spec_helper"
require "active_attr/typecasted_attributes"
require "active_attr/mass_assignment"

module ActiveAttr
  describe TypecastedAttributes do
    subject { model_class.new }

    let :model_class do
      Class.new do
        include TypecastedAttributes

        attribute :typeless
        attribute :object,    :type => Object
        attribute :boolean,   :type => Typecasting::Boolean
        attribute :date,      :type => Date
        attribute :date_time, :type => DateTime
        attribute :float,     :type => Float
        attribute :integer,   :type => Integer
        attribute :string,    :type => String
      end
    end

    context "when assigning nil" do
      it "a typeless attribute returns nil" do
        subject.typeless = nil
        subject.typeless.should be_nil
      end

      it "an Object attribute returns nil" do
        subject.object = nil
        subject.object.should be_nil
      end

      it "a Boolean attribute returns nil" do
        subject.boolean = nil
        subject.boolean.should be_nil
      end

      it "a Date attribute returns nil" do
        subject.date = nil
        subject.date.should be_nil
      end

      it "a DateTime attribute returns nil" do
        subject.date_time = nil
        subject.date_time.should be_nil
      end

      it "a Float attribute returns nil" do
        subject.float = nil
        subject.float.should be_nil
      end

      it "an Integer attribute returns nil" do
        subject.integer = nil
        subject.integer.should be_nil
      end

      it "a String attribute returns nil" do
        subject.string = nil
        subject.string.should be_nil
      end
    end

    context "when assigning a valid String" do
      it "a typeless attribute returns the original String" do
        value = "test"
        subject.typeless = value
        subject.typeless.should equal value
      end

      it "an Object attribute returns the original String" do
        value = "test"
        subject.object = value
        subject.object.should equal value
      end

      it "a Boolean attribute returns a Boolean" do
        subject.boolean = "false"
        subject.boolean.should eql false
      end

      it "a Date attribute returns a Date" do
        subject.date = "2012-01-01"
        subject.date.should eql Date.new(2012, 1, 1)
      end

      it "a DateTime attribute returns a DateTime" do
        subject.date_time = "2012-01-01"
        subject.date_time.should eql DateTime.new(2012, 1, 1)
      end

      it "a Float attribute returns a Float" do
        subject.float = "1.1"
        subject.float.should eql 1.1
      end

      it "an Integer attribute returns an Integer" do
        subject.integer = "1"
        subject.integer.should eql 1
      end

      it "a String attribute returns the String" do
        subject.string = "1.0"
        subject.string.should eql "1.0"
      end
    end
  end
end
