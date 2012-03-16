require "spec_helper"
require "active_attr/query_attributes"

module ActiveAttr
  describe QueryAttributes do
    context "defining dangerous attributes" do
      let :parent_class do
        Class.new.tap do |parent_class|
          parent_class.class_eval do
            include QueryAttributes
          end
        end
      end

      shared_examples "defining a dangerous queryable attribute" do
        it "defining an attribute that conflicts with ActiveModel::AttributeMethods raises DangerousAttributeError" do
          expect { model_class.attribute(:attribute_method) }.to raise_error DangerousAttributeError, %{an attribute method named "attribute_method?" would conflict with an existing method}
        end

        it "defining an attribute that conflicts with Kernel raises DangerousAttributeError" do
          expect { model_class.attribute(:block_given) }.to raise_error DangerousAttributeError
        end

        it "defining an attribute that conflicts with Object raises DangerousAttributeError" do
          expect { model_class.attribute(:nil) }.to raise_error DangerousAttributeError
        end
      end

      context "on a model class" do
        let(:model_class) { parent_class }
        include_examples "defining a dangerous queryable attribute"
      end

      context "on a child class" do
        let(:model_class) { Class.new(parent_class) }
        include_examples "defining a dangerous queryable attribute"
      end
    end
  end
end
