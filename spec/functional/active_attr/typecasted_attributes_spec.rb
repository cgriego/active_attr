require "spec_helper"
require "active_attr/typecasted_attributes"

module ActiveAttr
  describe TypecastedAttributes do
    subject(:model) { model_class.new }

    let :model_class do
      Class.new do
        include TypecastedAttributes

        attribute :typeless
        attribute :age,         :type => Age, :typecaster => lambda { |value| Age.new(value) }
        attribute :object,      :type => Object
        attribute :big_decimal, :type => BigDecimal
        attribute :boolean,     :type => Typecasting::Boolean
        attribute :date,        :type => Date
        attribute :date_time,   :type => DateTime
        attribute :float,       :type => Float
        attribute :integer,     :type => Integer
        attribute :string,      :type => String

        attribute :unknown, :type => Class.new {
          def self.to_s
            "Unknown"
          end
        }
      end
    end

    context "when assigning nil" do
      it "a typeless attribute returns nil" do
        model.typeless = nil
        model.typeless.should be_nil
      end

      it "an attribute with no known typecaster raises" do
        model.unknown = nil
        expect { model.unknown }.to raise_error Typecasting::UnknownTypecasterError, "Unable to cast to type Unknown"
      end

      it "an attribute with an inline typecaster returns nil" do
        model.age = nil
        model.age.should be_nil
      end

      it "an Object attribute returns nil" do
        model.object = nil
        model.object.should be_nil
      end

      it "a BigDecimal attribute returns nil" do
        model.big_decimal = nil
        model.big_decimal.should be_nil
      end

      it "a Boolean attribute returns nil" do
        model.boolean = nil
        model.boolean.should be_nil
      end

      it "a Date attribute returns nil" do
        model.date = nil
        model.date.should be_nil
      end

      it "a DateTime attribute returns nil" do
        model.date_time = nil
        model.date_time.should be_nil
      end

      it "a Float attribute returns nil" do
        model.float = nil
        model.float.should be_nil
      end

      it "an Integer attribute returns nil" do
        model.integer = nil
        model.integer.should be_nil
      end

      it "a String attribute returns nil" do
        model.string = nil
        model.string.should be_nil
      end
    end

    context "when assigning a valid String" do
      it "a typeless attribute returns the original String" do
        value = "test"
        model.typeless = value
        model.typeless.should equal value
      end

      it "an Object attribute returns the original String" do
        value = "test"
        model.object = value
        model.object.should equal value
      end

      it "a BigDecimal attribute returns a BigDecimal" do
        model.big_decimal = "1.1"
        model.big_decimal.should eql BigDecimal.new("1.1")
      end

      it "a Boolean attribute returns a Boolean" do
        model.boolean = "false"
        model.boolean.should eql false
      end

      it "a Date attribute returns a Date" do
        model.date = "2012-01-01"
        model.date.should eql Date.new(2012, 1, 1)
      end

      it "a Date attribute before typecasting returns the original String" do
        value = "2012-01-01"
        model.date = value
        model.date_before_type_cast.should equal value
      end

      it "a DateTime attribute returns a DateTime" do
        model.date_time = "2012-01-01"
        model.date_time.should eql DateTime.new(2012, 1, 1)
      end

      it "a Float attribute returns a Float" do
        model.float = "1.1"
        model.float.should eql 1.1
      end

      it "an Integer attribute returns an Integer" do
        model.integer = "1"
        model.integer.should eql 1
      end

      it "a String attribute returns the String" do
        model.string = "1.0"
        model.string.should eql "1.0"
      end

      it "an attribute using an inline typecaster returns the result of the inline typecaster" do
        model.age = 2
        model.age.should == Age.new(2)
      end
    end
  end
end
