require "spec_helper"
require "active_attr/attributes"
require "active_model"
require "factory_girl"

module ActiveAttr
  describe Attributes do
    context "defining multiple attributes" do
      let :model_class do
        Class.new do
          include Attributes

          attribute :name
          attribute :id

          def id
            if defined?(super)
              super
            else
              object_id
            end
          end unless instance_methods(false).include?("id")
        end
      end

      subject { model_class.new }

      it "correctly defines methods for the attributes instead of relying on method_missing" do
        subject.id.should be_nil
      end
    end

    context "subclassing a model" do
      let :parent_class do
        Class.new do
          include Attributes

          attribute :parent
          attribute :redefined, :type => Symbol
        end
      end

      let! :child_class do
        Class.new(parent_class).tap do |child_class|
          child_class.class_eval do
            attribute :child
            attribute :redefined, :type => String
          end
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
          child_class.attribute_names.should include "parent"
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
          parent_class.attribute_names.should_not include "child"
        end
      end

      context "attributes redefined on the child" do
        it "redefines the child attribute" do
          child_class.attributes[:redefined].should == AttributeDefinition.new(:redefined, :type => String)
        end

        it "does not redefine the parent attribute" do
          parent_class.attributes[:redefined].should == AttributeDefinition.new(:redefined, :type => Symbol)
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

          self.include_root_in_json = true
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

        FactoryGirl.define do
          factory :person, :class => :person do
            first_name "Chris"
            last_name "Griego"
          end
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
        subject.first_name.should eq "Chris"
        subject.last_name.should == "Griego"
      end
    end

    context "defining dangerous attributes" do
      shared_examples "a dangerous attribute" do
        it ".dangerous_attribute? is true" do
          model_class.dangerous_attribute?(attribute_name).should be_true
        end

        it ".attribute raises DangerousAttributeError" do
          expect { model_class.attribute(attribute_name) }.to raise_error DangerousAttributeError, %{an attribute method named "#{attribute_name}" would conflict with an existing method}
        end

        it ".attribute! does not raise" do
          expect { model_class.attribute!(attribute_name) }.not_to raise_error
        end
      end

      shared_examples "a whitelisted attribute" do
        it ".dangerous_attribute? is false" do
          model_class.dangerous_attribute?(attribute_name).should be_false
        end

        it ".attribute does not raise" do
          expect { model_class.attribute(attribute_name) }.not_to raise_error
        end

        it ".attribute! does not raise" do
          expect { model_class.attribute!(attribute_name) }.not_to raise_error
        end

        it "can be set and get" do
          model_class.attribute attribute_name
          model = model_class.new
          value = mock
          model.send "#{attribute_name}=", value
          model.send(attribute_name).should equal value
        end
      end

      shared_examples "defining dangerous attributes" do
        context "an attribute that conflicts with #{described_class}" do
          let(:attribute_name) { :write_attribute }
          include_examples "a dangerous attribute"
        end

        context "an attribute that conflicts with ActiveModel::AttributeMethods" do
          let(:attribute_name) { :inspect }
          include_examples "a dangerous attribute"
        end

        context "an attribute that conflicts with Kernel" do
          let(:attribute_name) { :puts }
          include_examples "a dangerous attribute"
        end

        context "an attribute that conflicts with Object" do
          let(:attribute_name) { :class }
          include_examples "a dangerous attribute"
        end

        context "an attribute that conflicts with BasicObject" do
          let(:attribute_name) { :instance_eval }
          include_examples "a dangerous attribute"
        end

        context "an attribute that conflicts with a properly implemented method_missing callback" do
          let(:attribute_name) { :my_proper_missing_method }
          include_examples "a dangerous attribute"
        end

        context "an attribute that conflicts with a less properly implemented method_missing callback" do
          let(:attribute_name) { :my_less_proper_missing_method }
          include_examples "a dangerous attribute"
        end

        context "an :id attribute" do
          let(:attribute_name) { :id }
          include_examples "a whitelisted attribute"
        end

        context "a :type attribute" do
          let(:attribute_name) { :type }
          include_examples "a whitelisted attribute"
        end
      end

      let :dangerous_model_class do
        Class.new.tap do |dangerous_model_class|
          dangerous_model_class.class_eval do
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
      end

      context "on a model class" do
        let(:model_class) { dangerous_model_class }
        include_examples "defining dangerous attributes"
      end

      context "on a child class" do
        let(:model_class) { Class.new(dangerous_model_class) }
        include_examples "defining dangerous attributes"
      end
    end
  end
end
