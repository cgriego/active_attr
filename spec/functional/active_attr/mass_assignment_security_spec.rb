require "spec_helper"
require "active_attr/mass_assignment_security"

module ActiveAttr
  describe MassAssignmentSecurity, :mass_assignment do
    context "integrating with strong_parameters", :active_model_version => "~> 3.2.0" do
      subject { model_class }

      before do
        require "strong_parameters"

        model_class.class_eval do
          include ActiveAttr::MassAssignmentSecurity
          include ActiveModel::ForbiddenAttributesProtection
          attr_accessor :age
        end
      end

      shared_examples "strong mass assignment method", :strong_mass_assignment_method => true do
        it "raises if provided parameters when none are permitted" do
          expect { mass_assign_attributes(ActionController::Parameters.new(:age => 21)) }.to raise_error ActiveModel::ForbiddenAttributes
        end

        it "sets a permitted parameter" do
          person = mass_assign_attributes(ActionController::Parameters.new(:age => 21).permit(:age))
          person.age.should == 21
        end

        it "does not set forbidden parameters" do
          person = mass_assign_attributes(ActionController::Parameters.new(:age => 21).permit(:first_name))
          person.age.should be_nil
        end

        it "continues to set normal attributes" do
          person = mass_assign_attributes(:age => 21)
          person.age.should == 21
        end
      end

      describe "#assign_attributes", :assign_attributes, :strong_mass_assignment_method
      describe "#attributes=", :attributes=, :strong_mass_assignment_method
      describe "#initialize", :initialize, :strong_mass_assignment_method
    end
  end
end
