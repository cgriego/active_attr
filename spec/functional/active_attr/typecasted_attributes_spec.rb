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
        expect(model.typeless).to be_nil
      end

      it "an attribute with no known typecaster raises" do
        model.unknown = nil
        expect { model.unknown }.to raise_error Typecasting::UnknownTypecasterError, "Unable to cast to type Unknown"
      end

      it "an attribute with an inline typecaster returns nil" do
        model.age = nil
        expect(model.age).to be_nil
      end

      it "an Object attribute returns nil" do
        model.object = nil
        expect(model.object).to be_nil
      end

      it "a BigDecimal attribute returns nil" do
        model.big_decimal = nil
        expect(model.big_decimal).to be_nil
      end

      it "a Boolean attribute returns nil" do
        model.boolean = nil
        expect(model.boolean).to be_nil
      end

      it "a Date attribute returns nil" do
        model.date = nil
        expect(model.date).to be_nil
      end

      it "a DateTime attribute returns nil" do
        model.date_time = nil
        expect(model.date_time).to be_nil
      end

      it "a Float attribute returns nil" do
        model.float = nil
        expect(model.float).to be_nil
      end

      it "an Integer attribute returns nil" do
        model.integer = nil
        expect(model.integer).to be_nil
      end

      it "a String attribute returns nil" do
        model.string = nil
        expect(model.string).to be_nil
      end
    end

    context "when assigning a valid String" do
      it "a typeless attribute returns the original String" do
        value = "test"
        model.typeless = value
        expect(model.typeless).to equal value
      end

      it "an Object attribute returns the original String" do
        value = "test"
        model.object = value
        expect(model.object).to equal value
      end

      it "a BigDecimal attribute returns a BigDecimal" do
        model.big_decimal = "1.1"
        expect(model.big_decimal).to eql BigDecimal.new("1.1")
      end

      it "a Boolean attribute returns a Boolean" do
        model.boolean = "false"
        expect(model.boolean).to eql false
      end

      it "a Date attribute returns a Date" do
        model.date = "2012-01-01"
        expect(model.date).to eql Date.new(2012, 1, 1)
      end

      it "a Date attribute before typecasting returns the original String" do
        value = "2012-01-01"
        model.date = value
        expect(model.date_before_type_cast).to equal value
      end

      it "a DateTime attribute returns a DateTime" do
        model.date_time = "2012-01-01"
        expect(model.date_time).to eql DateTime.new(2012, 1, 1)
      end

      it "a Float attribute returns a Float" do
        model.float = "1.1"
        expect(model.float).to eql 1.1
      end

      it "an Integer attribute returns an Integer" do
        model.integer = "1"
        expect(model.integer).to eql 1
      end

      it "a String attribute returns the String" do
        model.string = "1.0"
        expect(model.string).to eql "1.0"
      end

      it "an attribute using an inline typecaster returns the result of the inline typecaster" do
        model.age = 2
        expect(model.age).to eq(Age.new(2))
      end
    end
  end
end
