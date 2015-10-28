require "spec_helper"
require "active_attr/logger"

module ActiveAttr
  describe Logger do
    subject(:model) { model_class.new }
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
        expect(described_class.logger).to be_nil
      end

      it "#{described_class}.logger? is false" do
        expect(described_class.logger?).to eq(false)
      end

      it ".logger is nil" do
        expect(model_class.logger).to be_nil
      end

      it ".logger? is false" do
        expect(model_class.logger?).to eq(false)
      end

      it "#logger is nil" do
        expect(model.logger).to be_nil
      end

      it "#logger? is false" do
        expect(model.logger?).to eq(false)
      end
    end

    context "when the logger is set on the module" do
      before { described_class.logger = logger }
      after { described_class.logger = nil }

      it "#{described_class}.logger is the logger" do
        expect(described_class.logger).to eq(logger)
      end

      it "#{described_class}.logger? is true" do
        expect(described_class.logger?).to eq(true)
      end

      it ".logger is the logger" do
        expect(model_class.logger).to eq(logger)
      end

      it ".logger? is true" do
        expect(model_class.logger?).to eq(true)
      end

      it "#logger is the logger" do
        expect(model.logger).to eq(logger)
      end

      it "#logger? is true" do
        expect(model.logger?).to eq(true)
      end
    end

    context "when the logger is set on the class" do
      before { model_class.logger = logger }

      it "#{described_class}.logger is nil" do
        expect(described_class.logger).to be_nil
      end

      it "#{described_class}.logger? is false" do
        expect(described_class.logger?).to eq(false)
      end

      it ".logger is the logger" do
        expect(model_class.logger).to eq(logger)
      end

      it ".logger? is true" do
        expect(model_class.logger?).to eq(true)
      end

      it "#logger is the logger" do
        expect(model.logger).to eq(logger)
      end

      it "#logger? is true" do
        expect(model.logger?).to eq(true)
      end
    end

    context "when the logger is set on a parent class" do
      before { parent_class.logger = logger }
      subject(:model) { child_class.new }

      it "#{described_class}.logger is nil" do
        expect(described_class.logger).to be_nil
      end

      it "#{described_class}.logger? is false" do
        expect(described_class.logger?).to eq(false)
      end

      it ".logger is the logger" do
        expect(child_class.logger).to eq(logger)
      end

      it ".logger? is true" do
        expect(child_class.logger?).to eq(true)
      end

      it "#logger is the logger" do
        expect(model.logger).to eq(logger)
      end

      it "#logger? is true" do
        expect(model.logger?).to eq(true)
      end
    end

    context "when the logger is set on a child class" do
      before { child_class.logger = logger }
      subject(:model) { parent_class.new }

      it "#{described_class}.logger is nil" do
        expect(described_class.logger).to be_nil
      end

      it "#{described_class}.logger? is false" do
        expect(described_class.logger?).to eq(false)
      end

      it ".logger is nil" do
        expect(parent_class.logger).to be_nil
      end

      it ".logger? is false" do
        expect(parent_class.logger?).to eq(false)
      end

      it "#logger is nil" do
        expect(model.logger).to be_nil
      end

      it "#logger? is false" do
        expect(model.logger?).to eq(false)
      end
    end

    context "when the logger is set on the instance" do
      before { model.logger = logger }

      it "#{described_class}.logger is nil" do
        expect(described_class.logger).to be_nil
      end

      it "#{described_class}.logger? is false" do
        expect(described_class.logger?).to eq(false)
      end

      it ".logger is nil" do
        expect(model_class.logger).to be_nil
      end

      it ".logger? is false" do
        expect(model_class.logger?).to eq(false)
      end

      it "#logger is the logger" do
        expect(model.logger).to eq(logger)
      end

      it "#logger? is true" do
        expect(model.logger?).to eq(true)
      end
    end
  end
end
