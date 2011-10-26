require "spec_helper"
require "active_attr/attributes"

module ActiveAttr
  describe Attributes do
    subject { model_class.new }

    let :model_class do
      Class.new do
        include Attributes
        attribute :name
        attribute :amount

        def self.name
          "Foo"
        end

        def amount
          super
        end

        def amount=(*)
          super
        end

        def initialize(name=nil)
          super
          write_attribute(:name, name)
        end
      end
    end

    let :attributeless do
      Class.new do
        include Attributes

        def self.name
          "Foo"
        end
      end
    end

    describe ".attribute" do
      it "creates an attribute with no options" do
        model_class.attributes.should include(AttributeDefinition.new(:name))
      end

      it "returns the attribute definition" do
        Class.new(model_class).attribute(:address).should == AttributeDefinition.new(:address)
      end

      it "defines an attribute reader that calls #attribute" do
        subject.should_receive(:attribute).with("name")
        subject.name
      end

      it "defines an attribute reader that can be called via super" do
        subject.should_receive(:attribute).with("amount")
        subject.amount
      end

      it "defines an attribute writer that calls #attribute=" do
        subject.should_receive(:attribute=).with("name", "Ben")
        subject.name = "Ben"
      end

      it "defines an attribute writer that can be called via super" do
        subject.should_receive(:attribute=).with("amount", 1)
        subject.amount = 1
      end

      it "defining an attribute twice does not make appear in the" do
        Class.new do
          include Attributes
          attribute :name
          attribute :name
        end.should have(1).attributes
      end
    end

    describe ".attributes" do
      it { model_class.should respond_to(:attributes) }

      context "when no attributes exist" do
        it { attributeless.attributes.should be_empty }
      end
    end

    describe ".inspect" do
      it "renders the class name" do
        model_class.inspect.should match /^Foo\(.*\)$/
      end

      it "renders the attribute names in alphabetical order" do
        model_class.inspect.should match "(amount, name)"
      end

      it "doesn't format the inspection string for attributes if the model does not have any" do
        attributeless.inspect.should == "Foo"
      end
    end

    describe "#==" do
      subject { model_class.new("Ben") }

      it "returns true when all attributes are equal" do
        should == model_class.new("Ben")
      end

      it "returns false when compared to another type" do
        should_not == Struct.new(:attributes).new("name" => "Ben")
      end
    end

    describe "#attributes" do
      context "when no attributes are defined" do
        it "returns an empty Hash" do
          attributeless.new.attributes.should == {}
        end
      end

      context "when an attribute is defined" do
        it "returns the key value pairs" do
          subject.name = "Ben"
          subject.attributes.should include("name" => "Ben")
        end

        it "returns a new Hash " do
          subject.attributes.merge!("name" => "Bob")
          subject.attributes.should_not include("name" => "Bob")
        end

        it "returns all attributes" do
          subject.attributes.keys.should =~ %w(amount name)
        end
      end

      context "when a getter is overridden" do
        before do
          subject.extend Module.new {
            def name
              "Benjamin"
            end
          }
        end

        it "uses the overridden implementation" do
          subject.name = "Ben"
          subject.attributes.should include("name" => "Benjamin")
        end
      end
    end

    describe "#inspect" do
      before { subject.name = "Ben" }

      it "includes the class name and all attribute values in alphabetical order by attribute name" do
        subject.inspect.should == %q{#<Foo amount: nil, name: "Ben">}
      end

      it "doesn't format the inspection string for attributes if the model does not have any" do
        attributeless.new.inspect.should == %q{#<Foo>}
      end
    end

    [:[], :read_attribute].each do |method|
      describe "##{method}" do
        context "when an attribute is not set" do
          it "returns nil" do
            subject.send(method, :name).should == nil
          end
        end

        context "when an attribute is set" do
          let(:name) { "Bob" }

          before { subject.write_attribute(:name, name) }

          it "returns the attribute using a Symbol" do
            subject.send(method, :name).should == name
          end

          it "returns the attribute using a String" do
            subject.send(method, 'name').should == name
          end
        end
      end
    end

    [:[]=, :write_attribute].each do |method|
      describe "##{method}" do
        it "raises ArgumentError with one argument" do
          expect { subject.send(method, :name) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError with no arguments" do
          expect { subject.send(method) }.to raise_error(ArgumentError)
        end

        it "assigns sets an attribute using a Symbol and value" do
          expect { subject.send(method, :name, "Ben") }.to change { subject.attributes["name"] }.from(nil).to("Ben")
        end

        it "assigns sets an attribute using a String and value" do
          expect { subject.send(method, 'name', "Ben") }.to change { subject.attributes["name"] }.from(nil).to("Ben")
        end
      end
    end
  end
end
