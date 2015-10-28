require "spec_helper"
require "active_attr/attribute_defaults"
require "active_attr/mass_assignment"
require "active_attr/typecasted_attributes"
require "active_model"

module ActiveAttr
  describe AttributeDefaults do
    subject(:model) { model_class.new }

    let :model_class do
      Class.new.tap do |model_class|
        model_class.class_eval do
          include AttributeDefaults
        end
      end
    end

    context "an attribute with a default string" do
      before { model_class.attribute :first_name, :default => "John" }

      it "the attribute getter returns the string by default" do
        expect(model.first_name).to eq("John")
      end

      it "#attributes includes the default attributes" do
        expect(model.attributes["first_name"]).to eq("John")
      end

      it "#read_attribute returns the string by default" do
        expect(model.read_attribute("first_name")).to eq("John")
      end

      it "assigning nil sets nil as the attribute value" do
        model.first_name = nil
        expect(model.first_name).to be_nil
      end

      it "mutating the default value does not mutate the attribute definition" do
        model_class.new.first_name.upcase!
        expect(model_class.new.first_name).to eq("John")
      end
    end

    context "an attribute with a default of false" do
      before { model_class.attribute :admin, :default => false }

      it "the attribute getter returns false by default" do
        expect(model.admin).to eq(false)
      end
    end

    context "an attribute with a default of true" do
      before { model_class.attribute :remember_me, :default => true }

      it "the attribute getter returns true by default" do
        expect(model.remember_me).to eq(true)
      end
    end

    context "an attribute with a default empty Array" do
      before { model_class.attribute :roles, :default => [] }

      it "the attribute getter returns an empty array by default" do
        expect(model.roles).to eq([])
      end
    end

    context "an attribute with a dynamic Time.now default" do
      before { model_class.attribute :created_at, :default => lambda { Time.now } }

      it "the attribute getter returns a Time instance" do
        expect(model.created_at).to be_a_kind_of Time
      end

      it "the attribute default is only evaulated once per instance" do
        expect(model.created_at).to eq(model.created_at)
      end

      it "the attribute default is different per instance" do
        expect(model_class.new.created_at).not_to equal model_class.new.created_at
      end
    end

    context "an attribute with a default based on the instance" do
      before { model_class.attribute :id, :default => lambda { object_id } }

      it "the attribute getter returns the default based on the instance" do
        expect(model.id).to eq(model.object_id)
      end
    end

    context "combined with MassAssignment" do
      let :model_class do
        Class.new do
          include MassAssignment
          include AttributeDefaults

          attribute :start_date
          attribute :end_date, :default => lambda { start_date }
          attribute :age_limit, :default => 21
        end
      end

      it "applies the default attributes" do
        expect(model_class.new.age_limit).to eq(21)
      end

      it "mass assignment at initialization overrides the defaults" do
        expect(model_class.new(:age_limit => 18).age_limit).to eq(18)
      end

      it "mass assignment at initialization can override the default with a nil value" do
        expect(model_class.new(:age_limit => nil).age_limit).to be_nil
      end

      it "dynamic defaults have access to other attribute methods" do
        expect(model_class.new.end_date).to be_nil
      end

      it "dynamic defaults have access to attributes mass assigned at initialization" do
        expect(model_class.new(:start_date => Date.today).end_date).to eq(Date.today)
      end
    end

    context "combined with TypecastedAttributes" do
      let :model_class do
        Class.new do
          include TypecastedAttributes
          include AttributeDefaults

          attribute :age, :type => Integer, :default => "21"
          attribute :start_date, :type => String, :default => lambda { Date.today }
        end
      end

      it "typecasts a default value literal" do
        expect(model_class.new.age).to eq(21)
      end

      it "typecasts a dynamic default" do
        expect(model_class.new.start_date).to eq(Date.today.to_s)
      end
    end
  end
end
