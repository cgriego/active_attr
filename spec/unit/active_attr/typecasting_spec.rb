require "spec_helper"
require "active_attr/typecasting"

module ActiveAttr
  describe Typecasting do
    subject { model_class.new }

    let :model_class do
      Class.new do
        include Typecasting
      end
    end

    describe "#requires_typecasting?" do
      let(:type) { String }
      let(:subclass) { Class.new(String) }

      context "when the value is a subclass of the type" do
        subject { model_class.new.requires_typecasting?(type, subclass.new("1.0")) }
        it { should be_false }
      end

      context "when the value is of the same type" do
        subject { model_class.new.requires_typecasting?(type, "1.0") }
        it { should be_false }
      end

      context "when the value is not of the same type" do
        subject { model_class.new.requires_typecasting?(type, 1.0) }
        it { should be_true }
      end
    end

    describe "#typecast_attribute" do
      let(:type) { String }

      it "raises an ArgumentError when a nil type is given" do
        expect { subject.typecast_attribute(nil, "foo") }.to raise_error(ArgumentError, "a Class must be given")
      end

      context "when there is no way to typecast the value" do
        let(:value) { mock("SomeRandomValue") }

        it "returns nil" do
          subject.stub(:typecast_value).and_return(nil)
          subject.typecast_attribute(type, value).should be_nil
        end
      end

      context "when typecasting is not required" do
        let(:name) { "Ben" }
        let(:model) { model_class.new }
        subject { model.typecast_attribute(type, name) }

        it "returns the original value" do
          should eql name
        end

        it "does not call try to convert the value" do
          model.should_not_receive(:typecast_value)
          subject
        end
      end
    end

    describe "#typecast_value" do
      let(:model) { model_class.new }
      subject { model.typecast_value(type, value) }

      context "when typecasting to String" do
        let(:type) { String }
        let(:value) { mock(:to_s => "Ben") }

        it "calls #to_s" do
          should == "Ben"
        end
      end

      context "when typecasting to Float" do
        let(:type) { Float }
        let(:value) { mock(:to_f => 1.0) }

        it "calls #to_f" do
          should == 1.0
        end
      end

      context "when typecasting to Integer" do
        let(:type) { Integer }
        let(:value) { mock(:to_i => 1) }

        it "calls #to_i" do
          should == 1
        end

        context "from Float::INFINITY" do
          let(:value) { 1.0 / 0.0 }
          it { should be_nil }
        end

        context "from Float::NAN" do
          let(:value) { 0.0 / 0.0 }
          it { should be_nil }
        end
      end

      context "when typecasting to Date" do
        let(:type) { Date }
        let(:value) { mock(:to_date => date) }
        let(:date) { Date.parse("2012-01-01") }

        it "calls #to_date" do
          should == date
        end
      end

      context "when typecasting to DateTime" do
        let(:type) { DateTime }
        let(:value) { mock(:to_datetime => datetime) }
        let(:datetime) { DateTime.new }

        it "calls #to_datetime" do
          should == datetime
        end
      end

      context "when typecasting to Time" do
        let(:type) { Time }
        let(:value) { mock(:to_time => time) }
        let(:time) { Time.now }

        it "calls #to_time" do
          should == time
        end
      end
    end
  end
end
