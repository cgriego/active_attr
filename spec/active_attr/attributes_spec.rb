require "spec_helper"
require "active_attr/attributes"

module ActiveAttr
  describe Attributes do
    let(:model_class) do
      Class.new do
        include Attributes
        attribute :name
      end
    end

    subject do
      Class.new do
        include Attributes
        attribute :name
        attribute :amount

        def self.name
          "Foo"
        end
      end
    end

    describe ".attribute" do
      let(:instance) { subject.new }

      it "creates an attribute with no options" do
        subject.attributes.should include(AttributeDefinition.new(:name))
      end

      it "defined an attribute reader that calls #read_attribute" do
        instance.should_receive(:read_attribute).with(:name)
        instance.name
      end

      it "defines an attribute writer method that calls #write_attribute" do
        instance.should_receive(:write_attribute).with(:name, "Ben")
        instance.name = "Ben"
      end
    end

    describe ".attributes" do
      it { should respond_to(:attributes) }

      context "when no attributes exist" do
        subject do
          Class.new { include Attributes }.attributes
        end

        it "returns an empty Array" do
          should == []
        end
      end
    end

    describe ".inspect" do
      it "renders the class name" do
        subject.inspect.should match "Foo"
      end

      it "renders the attribute name and type" do
        subject.inspect.should match subject.attributes.map { |a| a.name }.join(", ")
      end
    end

    describe "#==" do
      let(:model_class) do
        Class.new do
          include Attributes
          attribute :name

          def initialize(name)
            write_attribute(:name, name)
          end
        end
      end

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
        subject { Class.new { include Attributes } }

        it "returns an empty Hash" do
          subject.new.attributes.should == {}
        end
      end
    end

    describe "#inspect" do
      let(:instance) { subject.new.tap { |obj| obj.name = "Ben" }  }

      it "includes the class name and all attribute values" do
        instance.inspect.should == %q{#<Foo name: "Ben", amount: nil>}
      end
    end

    describe "#read_attribute" do
      let(:name) { "Bob" }
      subject { model_class.new.tap { |s| s.write_attribute(:name, name) } }

      it "returns the attribute using a Symbol" do
        subject.read_attribute(:name).should == name
      end

      it "returns the attribute using a String" do
        subject.read_attribute('name').should == name
      end
    end

    describe "#write_attribute" do
      subject { model_class.new }

      it "raises ArgumentError with one argument" do
        expect { subject.write_attribute(:name) }.to raise_error(ArgumentError)
      end

      it "raises ArgumentError with no arguments" do
        expect { subject.write_attribute }.to raise_error(ArgumentError)
      end

      it "assigns sets an attribute using a Symbol and value" do
        expect { subject.write_attribute(:name, "Ben") }.to change(subject, :attributes).from({}).to("name" => "Ben")
      end

      it "assigns sets an attribute using a String and value" do
        expect { subject.write_attribute('name', "Ben") }.to change(subject, :attributes).from({}).to("name" => "Ben")
      end
    end
  end
end
