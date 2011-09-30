require "spec_helper"
require "active_attr/attributes"

module ActiveAttr
  describe Attributes do
    subject do
      Class.new do
        include Attributes
        active_attr :name
      end
    end

    describe ".active_attr" do
      it "creates an attribute with no options" do
        subject.attributes.should include(AttributeDefinition.new(:name))
      end
    end

    describe ".attributes" do
      it { should respond_to(:attributes) }

      context "when no attributes exist" do
        subject do
          Class.new do
            include Attributes
          end.attributes
        end

        it "returns an empty Array" do
          should == []
        end
      end
    end
  end
end
