require "spec_helper"
require "active_attr/attributes"
require "active_model"
require "factory_girl"

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

          if defined? ActiveModel::Serializable
            include ActiveModel::Serializable::JSON
            include ActiveModel::Serializable::XML
          else
            include ActiveModel::Serializers::JSON
            include ActiveModel::Serializers::Xml
          end

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

    context "building with FactoryGirl" do
      subject { FactoryGirl.build(:person) }

      before do
        Object.const_set("Person", model_class)

        Factory.define :person, :class => :person do |model|
          model.first_name "Chris"
          model.last_name "Griego"
        end
      end

      after do
        FactoryGirl.factories.clear
        Object.send :remove_const, "Person"
      end

      let :model_class do
        Class.new do
          include Attributes
          attribute :first_name
          attribute :last_name
        end
      end

      it "builds an instance of the model class" do
        should be_a_kind_of Person
      end

      it "sets the attributes" do
        subject.first_name.should == "Chris"
        subject.last_name.should == "Griego"
      end
    end

    context "defining dangerous attributes" do
      shared_examples "defining a dangerous attribute" do
        it "defining an attribute that conflicts with #{described_class} raises DangerousAttributeError" do
          expect { model_class.attribute(:write_attribute) }.to raise_error DangerousAttributeError, %{an attribute method named "write_attribute" would conflict with an existing method}
        end

        it "defining an attribute that conflicts with ActiveModel::AttributeMethods raises DangerousAttributeError" do
          expect { model_class.attribute(:attribute_method_matchers) }.to raise_error DangerousAttributeError, %{an attribute method named "attribute_method_matchers" would conflict with an existing method}
        end

        it "defining an :id attribute does not raise" do
          expect { model_class.attribute(:id) }.not_to raise_error
        end

        it "defining a :type attribute does not raise" do
          expect { model_class.attribute(:type) }.not_to raise_error
        end

        it "defining an attribute that conflicts with Kernel raises DangerousAttributeError" do
          expect { model_class.attribute(:puts) }.to raise_error DangerousAttributeError
        end

        it "defining an attribute that conflicts with Object raises DangerousAttributeError" do
          expect { model_class.attribute(:class) }.to raise_error DangerousAttributeError
        end

        it "defining an attribute that conflicts with BasicObject raises DangerousAttributeError" do
          expect { model_class.attribute(:instance_eval) }.to raise_error DangerousAttributeError
        end

        it "defining an attribute that conflicts with a properly implemented method_missing callback raises DangerousAttributeError" do
          expect { model_class.attribute(:my_proper_missing_method) }.to raise_error DangerousAttributeError
        end

        it "defining an attribute that conflicts with a less properly implemented method_missing callback raises DangerousAttributeError" do
          expect { model_class.attribute(:my_less_proper_missing_method) }.to raise_error DangerousAttributeError
        end
      end

      let :dangerous_model_class do
        Class.new do
          include Attributes

          def method_missing(method_name, *)
            super if %w(my_proper_missing_method my_less_proper_missing_method).include? method_name.to_s
          end

          def respond_to_missing?(method_name, *)
            method_name.to_s == "my_proper_missing_method" || super
          end

          def respond_to?(method_name, include_private=false)
            super || method_name.to_s == "my_less_proper_missing_method" || (RUBY_VERSION < "1.9" && respond_to_missing?(method_name, include_private))
          end
        end
      end

      context "on a model class" do
        let(:model_class) { dangerous_model_class }
        include_examples "defining a dangerous attribute"
      end

      context "on a child class" do
        let(:model_class) { Class.new(dangerous_model_class) }
        include_examples "defining a dangerous attribute"
      end
    end
  end
end
