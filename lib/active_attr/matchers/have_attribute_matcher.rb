module ActiveAttr
  module Matchers
    def have_attribute(attribute_name)
      HaveAttributeMatcher.new(attribute_name)
    end

    class HaveAttributeMatcher
      attr_reader :attribute_name

      def description
        "have attribute named #{attribute_name}"
      end

      def failure_message
        "Expected #{@model_class} to #{description}"
      end

      def initialize(attribute_name)
        @attribute_name = attribute_name
      end

      def matches?(model_or_model_class)
        @model_class = class_from(model_or_model_class)

        @model_class.attributes.any? do |attribute|
          attribute.name == attribute_name
        end
      end

      def negative_failure_message
        "Expected #{@model_class} to not #{description}"
      end

      private

      def class_from(object)
        Class === object ? object : object.class
      end
    end
  end
end
