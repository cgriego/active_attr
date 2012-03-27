require "spec_helper"
require "active_attr/basic_model"

module ActiveAttr
  describe BasicModel do
    let :model_class do
      Class.new do
        include BasicModel

        def self.name
          "Person"
        end
      end
    end

    subject { model_class.new }
    it_should_behave_like "ActiveModel"

    describe "#persisted?" do
      it "is not persisted by default" do
        subject.should_not be_persisted
      end
    end

    describe ".persisted" do
      let :persisted_class do
        Class.new(model_class) do
          always_persisted
        end
      end

      let :unpersisted_class do
        Class.new(model_class) do
          never_persisted
        end
      end

      let :lambda_class do
        Class.new(model_class) do
          persisted_when { |model| model.to_be_persisted? }
        end
      end

      describe "when persistence is true" do
        subject { persisted_class.new }
        it { should be_persisted }
      end

      describe "when persisted is false" do
        subject { unpersisted_class.new }
        it { should_not be_persisted }
      end

      describe "when persisted is a lambda" do
        subject { lambda_class.new }

        it "evaluates the lambda to determine persistence" do
          subject.stub(:to_be_persisted?).and_return(false)
          subject.should_not be_persisted

          subject.stub(:to_be_persisted?).and_return(true)
          subject.should be_persisted
        end
      end
    end
  end
end
