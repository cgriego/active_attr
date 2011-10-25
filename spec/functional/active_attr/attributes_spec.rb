require "spec_helper"
require "active_attr/attributes"
require "active_model"

module ActiveAttr
  describe Attributes do
    context "subclassing a model" do
      let :parent_class do
        Class.new do
          include Attributes

          attribute :parent
        end
      end

      let! :child_class do
        Class.new(parent_class) do
          attribute :child
        end
      end

      context "attributes defined on the parent" do
        subject { child_class.new }

        it "create a reader on the child" do
          should respond_to :parent
        end

        it "create a writer on the child" do
          should respond_to :parent=
        end

        it "add attribute definitions to the child" do
          child_class.attributes.map(&:name).should include :parent
        end
      end

      context "attributes defined on the child" do
        subject { parent_class.new }

        it "don't create a reader on the parent" do
          should_not respond_to :child
        end

        it "don't create a writer on the parent" do
          should_not respond_to :child=
        end

        it "don't add attribute definitions to the parent" do
          parent_class.attributes.map(&:name).should_not include :child
        end
      end
    end

    context "serializing a model" do
      let(:first_name) { "Chris" }

      let :instance do
        model_class.new.tap do |model|
          model.first_name = first_name
        end
      end

      let :model_class do
        Class.new do
          include Attributes
          include ActiveModel::Serializers::JSON
          include ActiveModel::Serializers::Xml

          attribute :first_name
          attribute :last_name

          def self.name
            "Person"
          end
        end
      end

      shared_examples "serialization method" do
        it "includes assigned attributes" do
          should include("first_name" => first_name)
        end

        it "includes unassigned, defined attributes" do
          subject.keys.should include("last_name")
          subject["last_name"].should be_nil
        end
      end

      describe "#as_json" do
        subject { instance.as_json["person"] }
        include_examples "serialization method"
      end

      describe "#serializable_hash" do
        subject { instance.serializable_hash }
        include_examples "serialization method"
      end

      describe "#to_json" do
        subject { ActiveSupport::JSON.decode(instance.to_json)["person"] }
        include_examples "serialization method"
      end

      describe "#to_xml" do
        subject { Hash.from_xml(instance.to_xml)["person"] }
        include_examples "serialization method"
      end
    end
  end
end
