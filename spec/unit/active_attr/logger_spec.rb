require "spec_helper"
require "active_attr/logger"

module ActiveAttr
  describe Logger do
    subject { model_class.new }
    let(:logger) { double "logger" }
    let(:child_class) { Class.new(parent_class) }
    let(:parent_class) { model_class }

    let :model_class do
      Class.new do
        include Logger
      end
    end

    context "when the logger is not set" do
      it "#{described_class}.logger is nil" do
        described_class.logger.should be_nil
      end

      it "#{described_class}.logger? is false" do
        described_class.logger?.should == false
      end

      it ".logger is nil" do
        model_class.logger.should be_nil
      end

      it ".logger? is false" do
        model_class.logger?.should == false
      end

      it "#logger is nil" do
        subject.logger.should be_nil
      end

      it "#logger? is false" do
        subject.logger?.should == false
      end
    end

    context "when the logger is set on the module" do
      before { described_class.logger = logger }
      after { described_class.logger = nil }

      it "#{described_class}.logger is the logger" do
        described_class.logger.should == logger
      end

      it "#{described_class}.logger? is true" do
        described_class.logger?.should == true
      end

      it ".logger is the logger" do
        model_class.logger.should == logger
      end

      it ".logger? is true" do
        model_class.logger?.should == true
      end

      it "#logger is the logger" do
        subject.logger.should == logger
      end

      it "#logger? is true" do
        subject.logger?.should == true
      end
    end

    context "when the logger is set on the class" do
      before { model_class.logger = logger }

      it "#{described_class}.logger is nil" do
        described_class.logger.should be_nil
      end

      it "#{described_class}.logger? is false" do
        described_class.logger?.should == false
      end

      it ".logger is the logger" do
        model_class.logger.should == logger
      end

      it ".logger? is true" do
        model_class.logger?.should == true
      end

      it "#logger is the logger" do
        subject.logger.should == logger
      end

      it "#logger? is true" do
        subject.logger?.should == true
      end
    end

    context "when the logger is set on a parent class" do
      before { parent_class.logger = logger }
      subject { child_class.new }

      it "#{described_class}.logger is nil" do
        described_class.logger.should be_nil
      end

      it "#{described_class}.logger? is false" do
        described_class.logger?.should == false
      end

      it ".logger is the logger" do
        child_class.logger.should == logger
      end

      it ".logger? is true" do
        child_class.logger?.should == true
      end

      it "#logger is the logger" do
        subject.logger.should == logger
      end

      it "#logger? is true" do
        subject.logger?.should == true
      end
    end

    context "when the logger is set on a child class" do
      before { child_class.logger = logger }
      subject { parent_class.new }

      it "#{described_class}.logger is nil" do
        described_class.logger.should be_nil
      end

      it "#{described_class}.logger? is false" do
        described_class.logger?.should == false
      end

      it ".logger is nil" do
        parent_class.logger.should be_nil
      end

      it ".logger? is false" do
        parent_class.logger?.should == false
      end

      it "#logger is nil" do
        subject.logger.should be_nil
      end

      it "#logger? is false" do
        subject.logger?.should == false
      end
    end

    context "when the logger is set on the instance" do
      before { subject.logger = logger }

      it "#{described_class}.logger is nil" do
        described_class.logger.should be_nil
      end

      it "#{described_class}.logger? is false" do
        described_class.logger?.should == false
      end

      it ".logger is nil" do
        model_class.logger.should be_nil
      end

      it ".logger? is false" do
        model_class.logger?.should == false
      end

      it "#logger is the logger" do
        subject.logger.should == logger
      end

      it "#logger? is true" do
        subject.logger?.should == true
      end
    end
  end
end
