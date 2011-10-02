require "spec_helper"
require "active_attr/mass_assignment"

module ActiveAttr
  describe MassAssignment do
    subject do
      Class.new do
        include MassAssignment

        attr_accessor :first_name, :last_name, :middle_name
        private :middle_name=

        def name=(name)
          self.last_name, self.first_name = name.split(nil, 2).reverse
        end
      end
    end

    let(:person) { subject.new }
    let(:first_name) { "Chris" }
    let(:last_name) { "Griego" }

    def should_assign_names_to(person)
      person.first_name.should == first_name
      person.last_name.should == last_name
    end

    shared_examples_for "a mass assigning method" do
      it "does not raise when assigning nil attributes" do
        expect { mass_assign_attributes nil }.not_to raise_error
      end

      it "assigns all valid attributes when passed as a hash with string keys" do
        should_assign_names_to mass_assign_attributes('first_name' => first_name, 'last_name' => last_name)
      end

      it "assigns all valid attributes when passed as a hash with symbol keys" do
        should_assign_names_to mass_assign_attributes(:first_name => first_name, :last_name => last_name)
      end

      it "uses any available writer methods" do
        should_assign_names_to mass_assign_attributes(:name => "#{first_name} #{last_name}")
      end

      it "ignores attributes which do not have a writer" do
        person = mass_assign_attributes(:middle_initial => "J")
        person.instance_variable_get("@middle_initial").should be_nil
        person.should_not respond_to :middle_initial
      end

      it "ignores trying to assign a private attribute" do
        person = mass_assign_attributes(:middle_name => "J")
        person.middle_name.should be_nil
      end
    end

    describe "#assign_attributes" do
      it "raises ArgumentError when called with three arguments" do
        expect { subject.new.assign_attributes({}, {}, nil) }.to raise_error ArgumentError
      end

      it "does not raise when called with two arguments" do
        expect { subject.new.assign_attributes({}, {}) }.not_to raise_error
      end

      it "does not raise when called with a single argument" do
        expect { subject.new.assign_attributes({}) }.not_to raise_error
      end

      it "raises ArgumentError when called with no arguments" do
        expect { subject.new.assign_attributes }.to raise_error ArgumentError
      end

      def mass_assign_attributes(attributes)
        person.assign_attributes attributes
        person
      end

      it_should_behave_like "a mass assigning method"
    end

    describe "#attributes=" do
      it "raises ArgumentError when called with two arguments" do
        expect { person.send(:attributes=, {}, {}) }.to raise_error ArgumentError
      end

      def mass_assign_attributes(attributes)
        person.attributes = attributes
        person
      end

      it_should_behave_like "a mass assigning method"
    end

    describe "#initialize" do
      it "raises ArgumentError when called with three arguments" do
        expect { subject.new({}, {}, nil) }.to raise_error ArgumentError
      end

      it "does not raise when called with two arguments" do
        expect { subject.new({}, {}) }.not_to raise_error
      end

      it "does not raise when called with a single argument" do
        expect { subject.new({}) }.not_to raise_error
      end

      it "does not raise when called with no arguments" do
        expect { subject.new }.not_to raise_error
      end

      def mass_assign_attributes(attributes)
        subject.new(attributes)
      end

      it_should_behave_like "a mass assigning method"
    end
  end
end
