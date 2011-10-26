require "spec_helper"
require "active_attr/strict_mass_assignment"

module ActiveAttr
  describe StrictMassAssignment, :mass_assignment do
    subject do
      model_class.class_eval do
        include StrictMassAssignment
      end
    end

    shared_examples "strict mass assignment method", :strict_mass_assignment_method => true do
      include_examples "mass assignment method"

      it "raises when assigning an unknown attribute" do
        expect do
          mass_assign_attributes(:middle_initial => "J")
        end.to raise_error UnknownAttributesError, "unknown attribute(s): middle_initial"
      end

      it "raises when trying to assign a private attribute" do
        expect do
          mass_assign_attributes(:middle_name => "J")
        end.to raise_error UnknownAttributesError, "unknown attribute(s): middle_name"
      end

      it "raises when assigning multiple unknown attributes with a message referencing both in alphabetical order" do
        expect do
          mass_assign_attributes(:middle_name => "J", :middle_initial => "J")
        end.to raise_error UnknownAttributesError, "unknown attribute(s): middle_initial, middle_name"
      end
    end

    describe "#assign_attributes", :assign_attributes, :strict_mass_assignment_method
    describe "#attributes=", :attributes=, :strict_mass_assignment_method
    describe "#initialize", :initialize, :strict_mass_assignment_method
  end
end
