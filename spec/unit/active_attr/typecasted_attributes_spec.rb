require "spec_helper"
require "active_attr/typecasted_attributes"

module ActiveAttr
  describe TypecastedAttributes do
    subject { model_class.new }

    let :model_class do
      Class.new do
        include TypecastedAttributes

        attribute :amount, :type => String
        attribute :first_name
        attribute :last_name

        def last_name_before_type_cast
          super
        end

        def self.name
          "Foo"
        end
      end
    end

    let :attributeless do
      Class.new do
        include TypecastedAttributes

        def self.name
          "Foo"
        end
      end
    end

    describe ".attribute" do
      it "defines an attribute pre-typecasting reader that calls #attribute_before_type_cast" do
        subject.should_receive(:attribute_before_type_cast).with("first_name")
        subject.first_name_before_type_cast
      end

      it "defines an attribute reader that can be called via super" do
        subject.should_receive(:attribute_before_type_cast).with("last_name")
        subject.last_name_before_type_cast
      end

      context "MultiValue" do
        before do
          model_class.class_eval do
            attribute :time, :type => Time
            attribute :date, :type => Date
          end
        end

        it "typecasts MultiValue to time" do
          subject.time = ActiveAttr::MultiAttr.new(1 => "2010", 2 => "10", 3 => "5")
          subject.time.should == Time.local(2010, 10, 5)
        end

        it "typecasts MultiValue to date" do
          subject.date = ActiveAttr::MultiAttr.new(1 => "2010", 2 => "10", 3 => "5")
          subject.date.should == Date.new(2010, 10, 5)
        end

        context "custom class" do
          it "typecasts MultiValue to custom class" do
            custom_class = Class.new do
              attr_accessor :a, :b
              def initialize(a, b)
                self.a = a
                self.b = b
              end
            end
            model_class.class_eval do
              attribute :custom, :type => custom_class
            end

            subject.custom = MultiAttr.new(1 => "foo", 2 => "bar")
            result = subject.custom
            result.should be_a(custom_class)
            result.a.should == "foo"
            result.b.should == "bar"
          end
        end

        it "raises ActiveAttr::MultiAttr::MissingParameter on arguments error" do
          subject.time = MultiAttr.new(1 => "2010", 3 => "5")
          expect { subject.time }.to raise_error(ActiveAttr::MultiAttr::MissingParameter)
        end
      end
    end

    describe ".inspect" do
      it "renders the class name" do
        model_class.inspect.should match(/^Foo\(.*\)$/)
      end

      it "renders the attribute names and types in alphabetical order, using Object for undeclared types" do
        model_class.inspect.should match "(amount: String, first_name: Object, last_name: Object)"
      end

      it "doesn't format the inspection string for attributes if the model does not have any" do
        attributeless.inspect.should == "Foo"
      end
    end

    describe "#attribute_before_type_cast" do
      it "returns the assigned attribute value, without typecasting, when given an attribute name as a Symbol" do
        value = :value
        subject.amount = value
        subject.attribute_before_type_cast(:amount).should equal value
      end

      it "returns the assigned attribute value, without typecasting, when given an attribute name as a String" do
        value = :value
        subject.amount = value
        subject.attribute_before_type_cast('amount').should equal value
      end
    end
  end
end
