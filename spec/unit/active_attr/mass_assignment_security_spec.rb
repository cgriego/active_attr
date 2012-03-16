require "spec_helper"
require "active_attr/mass_assignment_security"

module ActiveAttr
  describe MassAssignmentSecurity, :mass_assignment do
    subject { model_class }

    before do
      model_class.class_eval do
        include MassAssignmentSecurity
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
end
