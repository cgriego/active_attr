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
        model.should_receive(:attribute?).with("value")
        model.value?
      end

      it "defines an attribute reader that can be called via super" do
        model.should_receive(:attribute?).with("overridden")
        model.overridden?
      end
    end

    describe "#query_attribute" do
      it "raises ArgumentError when called with two arguments" do
        expect { model.query_attribute(:a, :b) }.to raise_error ArgumentError
      end

      it "does not raise when called with a single argument" do
        expect { model.query_attribute(:a) }.not_to raise_error ArgumentError
      end

      it "raises ArgumentError when called with no arguments" do
        expect { model.query_attribute }.to raise_error ArgumentError
      end

      it "calls the predicate method if defined" do
        model.query_attribute(:true).should eq true
        model.query_attribute(:false).should == false
      end

      it "raises when getting an undefined attribute" do
        expect { model.query_attribute(:initials) }.to raise_error UnknownAttributeError, "unknown attribute: initials"
      end

      it "is false when the attribute is false" do
        model.value = false
        model.value?.should == false
      end

      it "is true when the attribute is true" do
        model.value = true
        model.value?.should == true
      end

      it "is false when the attribute is nil" do
        model.value = nil
        model.value?.should == false
      end

      it "is true when the attribute is an Object" do
        model.value = Object.new
        model.value?.should == true
      end

      it "is false when the attribute is an empty string" do
        model.value = ""
        model.value?.should == false
      end

      it "is true when the attribute is a non-empty string" do
        model.value = "Chris"
        model.value?.should == true
      end

      it "is false when the attribute is 0" do
        model.value = 0
        model.value?.should == false
      end

      it "is true when the attribute is 1" do
        model.value = 1
        model.value?.should == true
      end

      it "is false when the attribute is 0.0" do
        model.value = 0.0
        model.value?.should == false
      end

      it "is true when the attribute is 0.1" do
        model.value = 0.1
        model.value?.should == true
      end

      it "is false when the attribute is a zero BigDecimal" do
        model.value = BigDecimal.new("0.0")
        model.value?.should == false
      end

      it "is true when the attribute is a non-zero BigDecimal" do
        model.value = BigDecimal.new("0.1")
        model.value?.should == true
      end

      it "is true when the attribute is -1" do
        model.value = -1
        model.value?.should == true
      end

      it "is false when the attribute is -0.0" do
        model.value = -0.0
        model.value?.should == false
      end

      it "is true when the attribute is -0.1" do
        model.value = -0.1
        model.value?.should == true
      end

      it "is false when the attribute is a negative zero BigDecimal" do
        model.value = BigDecimal.new("-0.0")
        model.value?.should == false
      end

      it "is true when the attribute is a negative BigDecimal" do
        model.value = BigDecimal.new("-0.1")
        model.value?.should == true
      end

      it "is false when the attribute is '0'" do
        model.value = "0"
        model.value?.should == false
      end

      it "is true when the attribute is '1'" do
        model.value = "1"
        model.value?.should == true
      end

      it "is false when the attribute is '0.0'" do
        model.value = "0.0"
        model.value?.should == false
      end

      it "is true when the attribute is '0.1'" do
        model.value = "0.1"
        model.value?.should == true
      end

      it "is true when the attribute is '-1'" do
        model.value = "-1"
        model.value?.should == true
      end

      it "is false when the attribute is '-0.0'" do
        model.value = "-0.0"
        model.value?.should == false
      end

      it "is true when the attribute is '-0.1'" do
        model.value = "-0.1"
        model.value?.should == true
      end

      it "is true when the attribute is 'true'" do
        model.value = "true"
        model.value?.should == true
      end

      it "is false when the attribute is 'false'" do
        model.value = "false"
        model.value?.should == false
      end

      it "is true when the attribute is 't'" do
        model.value = "t"
        model.value?.should == true
      end

      it "is false when the attribute is 'f'" do
        model.value = "f"
        model.value?.should == false
      end

      it "is true when the attribute is 'T'" do
        model.value = "T"
        model.value?.should == true
      end

      it "is false when the attribute is 'F'" do
        model.value = "F"
        model.value?.should == false
      end

      it "is true when the attribute is 'TRUE'" do
        model.value = "TRUE"
        model.value?.should == true
      end

      it "is false when the attribute is 'FALSE" do
        model.value = "FALSE"
        model.value?.should == false
      end
    end
  end
end
