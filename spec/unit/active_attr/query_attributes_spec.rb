require "spec_helper"
require "active_attr/query_attributes"
require "bigdecimal"

module ActiveAttr
  describe QueryAttributes do
    subject { model_class.new }

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
        subject.should_receive(:attribute?).with("value")
        subject.value?
      end

      it "defines an attribute reader that can be called via super" do
        subject.should_receive(:attribute?).with("overridden")
        subject.overridden?
      end
    end

    describe "#query_attribute" do
      it "raises ArgumentError when called with two arguments" do
        expect { subject.query_attribute(:a, :b) }.to raise_error ArgumentError
      end

      it "does not raise when called with a single argument" do
        expect { subject.query_attribute(:a) }.not_to raise_error ArgumentError
      end

      it "raises ArgumentError when called with no arguments" do
        expect { subject.query_attribute }.to raise_error ArgumentError
      end

      it "calls the predicate method if defined" do
        subject.query_attribute(:true).should eq true
        subject.query_attribute(:false).should == false
      end

      it "raises when getting an undefined attribute" do
        expect { subject.query_attribute(:initials) }.to raise_error UnknownAttributeError, "unknown attribute: initials"
      end

      it "is false when the attribute is false" do
        subject.value = false
        subject.value?.should == false
      end

      it "is true when the attribute is true" do
        subject.value = true
        subject.value?.should == true
      end

      it "is false when the attribute is nil" do
        subject.value = nil
        subject.value?.should == false
      end

      it "is true when the attribute is an Object" do
        subject.value = Object.new
        subject.value?.should == true
      end

      it "is false when the attribute is an empty string" do
        subject.value = ""
        subject.value?.should == false
      end

      it "is true when the attribute is a non-empty string" do
        subject.value = "Chris"
        subject.value?.should == true
      end

      it "is false when the attribute is 0" do
        subject.value = 0
        subject.value?.should == false
      end

      it "is true when the attribute is 1" do
        subject.value = 1
        subject.value?.should == true
      end

      it "is false when the attribute is 0.0" do
        subject.value = 0.0
        subject.value?.should == false
      end

      it "is true when the attribute is 0.1" do
        subject.value = 0.1
        subject.value?.should == true
      end

      it "is false when the attribute is a zero BigDecimal" do
        subject.value = BigDecimal.new("0.0")
        subject.value?.should == false
      end

      it "is true when the attribute is a non-zero BigDecimal" do
        subject.value = BigDecimal.new("0.1")
        subject.value?.should == true
      end

      it "is true when the attribute is -1" do
        subject.value = -1
        subject.value?.should == true
      end

      it "is false when the attribute is -0.0" do
        subject.value = -0.0
        subject.value?.should == false
      end

      it "is true when the attribute is -0.1" do
        subject.value = -0.1
        subject.value?.should == true
      end

      it "is false when the attribute is a negative zero BigDecimal" do
        subject.value = BigDecimal.new("-0.0")
        subject.value?.should == false
      end

      it "is true when the attribute is a negative BigDecimal" do
        subject.value = BigDecimal.new("-0.1")
        subject.value?.should == true
      end

      it "is false when the attribute is '0'" do
        subject.value = "0"
        subject.value?.should == false
      end

      it "is true when the attribute is '1'" do
        subject.value = "1"
        subject.value?.should == true
      end

      it "is false when the attribute is '0.0'" do
        subject.value = "0.0"
        subject.value?.should == false
      end

      it "is true when the attribute is '0.1'" do
        subject.value = "0.1"
        subject.value?.should == true
      end

      it "is true when the attribute is '-1'" do
        subject.value = "-1"
        subject.value?.should == true
      end

      it "is false when the attribute is '-0.0'" do
        subject.value = "-0.0"
        subject.value?.should == false
      end

      it "is true when the attribute is '-0.1'" do
        subject.value = "-0.1"
        subject.value?.should == true
      end

      it "is true when the attribute is 'true'" do
        subject.value = "true"
        subject.value?.should == true
      end

      it "is false when the attribute is 'false'" do
        subject.value = "false"
        subject.value?.should == false
      end

      it "is true when the attribute is 't'" do
        subject.value = "t"
        subject.value?.should == true
      end

      it "is false when the attribute is 'f'" do
        subject.value = "f"
        subject.value?.should == false
      end

      it "is true when the attribute is 'T'" do
        subject.value = "T"
        subject.value?.should == true
      end

      it "is false when the attribute is 'F'" do
        subject.value = "F"
        subject.value?.should == false
      end

      it "is true when the attribute is 'TRUE'" do
        subject.value = "TRUE"
        subject.value?.should == true
      end

      it "is false when the attribute is 'FALSE" do
        subject.value = "FALSE"
        subject.value?.should == false
      end
    end
  end
end
