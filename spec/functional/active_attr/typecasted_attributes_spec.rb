require "spec_helper"
require "active_attr/typecasted_attributes"
require "active_attr/mass_assignment"

module ActiveAttr
  describe TypecastedAttributes do
    let(:money_class) do
      Class.new do
        attr_accessor :amount

        def self.name
          "Money"
        end

        def initialize(amount)
          @amount = amount
        end

        def typecast_to_string
          sprintf("%.2f", amount)
        end
      end
    end

    let :model_class do
      Class.new do
        include TypecastedAttributes
        attribute :amount, :type => String

        def initialize(amount)
          super
          write_attribute(:amount, amount)
        end
      end
    end

    context "when no typecasting is required" do
      subject { model_class.new("1.0") }

      it "returns the value" do
        subject.amount.should == "1.0"
      end
    end

    context "when a custom typecasting method is defined" do
      subject { model_class.new(money_class.new(1.0)) }

      it "prefers the #typecast_to_string method" do
        subject.amount.should == "1.00"
      end
    end
  end
end
