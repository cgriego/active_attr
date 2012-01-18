require "spec_helper"
require "active_attr/typecasted_attributes"
require "active_attr/mass_assignment"

module ActiveAttr
  describe TypecastedAttributes do
    subject { model_class.new }

    let :model_class do
      Class.new do
        include TypecastedAttributes

        attribute :date,    :type => Date
        attribute :float,   :type => Float
        attribute :integer, :type => Integer
        attribute :string,  :type => String
      end
    end

    context "when assigning nil" do
      it "a Date attribute returns nil" do
        subject.date = nil
        subject.date.should be_nil
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
      it "a Date attribute returns a Date" do
        subject.date = "2012-01-01"
        subject.date.should == Date.new(2012, 1, 1)
      end

      it "a Float attribute returns a Float" do
        subject.float = "1.1"
        subject.float.should == 1.1
      end

      it "an Integer attribute returns an Integer" do
        subject.integer = "1"
        subject.integer.should == 1
      end

      it "a String attribute returns the String" do
        subject.string = "1.0"
        subject.string.should == "1.0"
      end
    end
  end
end
