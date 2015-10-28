require "spec_helper"
require "active_attr/query_attributes"
require "bigdecimal"

module ActiveAttr
  describe QueryAttributes do
    subject(:model) { model_class.new }

    let :model_class do
      Class.new do
        include QueryAttributes

        attribute :value
        attribute :overridden

        def overridden?
          super
        end

        def true?
          true
        end

        def false?
          false
        end
      end
    end

    describe ".attribute" do
      it "defines an attribute predicate method that calls #attribute?" do
        expect(model).to receive(:attribute?).with("value")
        model.value?
      end

      it "defines an attribute reader that can be called via super" do
        expect(model).to receive(:attribute?).with("overridden")
        model.overridden?
      end
    end

    describe "#query_attribute" do
      it "raises ArgumentError when called with two arguments" do
        expect { model.query_attribute(:a, :b) }.to raise_error ArgumentError
      end

      it "does not raise when called with a single argument" do
        expect { model.query_attribute(:value) }.not_to raise_error
      end

      it "raises ArgumentError when called with no arguments" do
        expect { model.query_attribute }.to raise_error ArgumentError
      end

      it "calls the predicate method if defined" do
        expect(model.query_attribute(:true)).to eq true
        expect(model.query_attribute(:false)).to eq(false)
      end

      it "raises when getting an undefined attribute" do
        expect { model.query_attribute(:initials) }.to raise_error UnknownAttributeError, "unknown attribute: initials"
      end

      it "is false when the attribute is false" do
        model.value = false
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is true" do
        model.value = true
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is nil" do
        model.value = nil
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is an Object" do
        model.value = Object.new
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is an empty string" do
        model.value = ""
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is a non-empty string" do
        model.value = "Chris"
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is 0" do
        model.value = 0
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is 1" do
        model.value = 1
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is 0.0" do
        model.value = 0.0
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is 0.1" do
        model.value = 0.1
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is a zero BigDecimal" do
        model.value = BigDecimal.new("0.0")
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is a non-zero BigDecimal" do
        model.value = BigDecimal.new("0.1")
        expect(model.value?).to eq(true)
      end

      it "is true when the attribute is -1" do
        model.value = -1
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is -0.0" do
        model.value = -0.0
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is -0.1" do
        model.value = -0.1
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is a negative zero BigDecimal" do
        model.value = BigDecimal.new("-0.0")
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is a negative BigDecimal" do
        model.value = BigDecimal.new("-0.1")
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is '0'" do
        model.value = "0"
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is '1'" do
        model.value = "1"
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is '0.0'" do
        model.value = "0.0"
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is '0.1'" do
        model.value = "0.1"
        expect(model.value?).to eq(true)
      end

      it "is true when the attribute is '-1'" do
        model.value = "-1"
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is '-0.0'" do
        model.value = "-0.0"
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is '-0.1'" do
        model.value = "-0.1"
        expect(model.value?).to eq(true)
      end

      it "is true when the attribute is 'true'" do
        model.value = "true"
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is 'false'" do
        model.value = "false"
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is 't'" do
        model.value = "t"
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is 'f'" do
        model.value = "f"
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is 'T'" do
        model.value = "T"
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is 'F'" do
        model.value = "F"
        expect(model.value?).to eq(false)
      end

      it "is true when the attribute is 'TRUE'" do
        model.value = "TRUE"
        expect(model.value?).to eq(true)
      end

      it "is false when the attribute is 'FALSE" do
        model.value = "FALSE"
        expect(model.value?).to eq(false)
      end
    end
  end
end
