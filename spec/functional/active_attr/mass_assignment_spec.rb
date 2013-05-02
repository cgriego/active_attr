require "spec_helper"
require "active_attr/mass_assignment"
require "active_model"
require "active_model/mass_assignment_security"

module ActiveAttr
  describe MassAssignment, :mass_assignment do
    context "integrating with protected_attributes" do
      before do
        model_class.class_eval do
          include MassAssignment
          include ActiveModel::MassAssignmentSecurity
          attr_accessor :age
        end
      end

      shared_examples "secure mass assignment method", :secure_mass_assignment_method => true do
        include_examples "mass assignment method"

        it "ignores assigning an attribute protected by role-based security", :active_model_version => ">= 3.1.0" do
          person = mass_assign_attributes(:age => 21)
          person.age.should be_nil
        end

        it "ignores assigning a protected attribute" do
          person = mass_assign_attributes(:first_name => "Chris")
          person.age.should be_nil
        end
      end

      shared_examples "secure mass assignment method with options", :secure_mass_assignment_method_with_options => true do
        it "supports role-based mass assignment security", :active_model_version => ">= 3.1.0" do
          person = mass_assign_attributes_with_options({ :age => 21 }, :as => :admin)
          person.age.should == 21
        end

        it "skips security if passed the :without_protection option" do
          person = mass_assign_attributes_with_options({ :age => 21 }, :without_protection => true)
          person.age.should == 21
        end
      end

      context "white listing attributes" do
        before do
          model_class.class_eval do
            attr_accessible :first_name, :last_name, :name
            attr_accessible :age, :as => :admin
          end
        end

        describe "#assign_attributes", :assign_attributes, :secure_mass_assignment_method, :secure_mass_assignment_method_with_options
        describe "#attributes=", :attributes=, :secure_mass_assignment_method
        describe "#initialize", :initialize, :secure_mass_assignment_method, :secure_mass_assignment_method_with_options
      end

      context "black listing attributes" do
        before do
          model_class.class_eval do
            attr_protected :age
            attr_protected :as => :admin
          end
        end

        describe "#assign_attributes", :assign_attributes, :secure_mass_assignment_method, :secure_mass_assignment_method_with_options
        describe "#attributes=", :attributes=, :secure_mass_assignment_method
        describe "#initialize", :initialize, :secure_mass_assignment_method, :secure_mass_assignment_method_with_options
      end
    end

    context "integrating with strong_parameters", :active_model_version => ">= 3.2.0" do
      let(:rails3) { Gem::Requirement.create("~> 3.2.0").satisfied_by?(Gem::Version.new(ActiveModel::VERSION::STRING)) }

      before do
        if rails3
          require "strong_parameters"

          model_class.class_eval do
            include ActiveAttr::MassAssignment
            include ActiveModel::MassAssignmentSecurity
            include ActiveModel::ForbiddenAttributesProtection
            attr_accessor :age
          end
        else
          require "action_controller"

          model_class.class_eval do
            include ActiveAttr::MassAssignment
            include ActiveModel::MassAssignmentSecurity
            include ActiveModel::ForbiddenAttributesProtection
            attr_accessor :age
          end
        end
      end

      let :forbidden_attributes_error_class do
        rails3 ? ActiveModel::ForbiddenAttributes : ActiveModel::ForbiddenAttributesError
      end

      shared_examples "strong mass assignment method", :strong_mass_assignment_method => true do
        it "raises if provided parameters when none are permitted" do
          expect { mass_assign_attributes(ActionController::Parameters.new(:age => 21)) }.to raise_error forbidden_attributes_error_class
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
