require "spec_helper"
require "active_attr/attributes"

module ActiveAttr
  describe Attributes do
    describe "subclassing models" do
      let :parent_class do
        Class.new do
          include Attributes

          attribute :parent

          def self.name
            "Parent"
          end
        end
      end

      let! :child_class do
        Class.new(parent_class) do
          attribute :child

          def self.name
            "Child"
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
  end
end
