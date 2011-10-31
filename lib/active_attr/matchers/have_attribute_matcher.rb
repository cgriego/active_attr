module ActiveAttr
  module Matchers
    # Specify that a model should have an attribute matching the criteria
    #
    # @example Person should have a name attribute
    #   describe Person do
    #     it { should have_attribute(:name) }
    #   end
    #
    # @param [Symbol, String, #to_sym] attribute_name
    #
    # @return [ActiveAttr::HaveAttributeMatcher]
    #
    # @since 0.2.0
    def have_attribute(attribute_name)
      HaveAttributeMatcher.new(attribute_name)
    end

    # Verifies that an ActiveAttr-based model has an attribute matching the
    # given criteria
    #
    # @since 0.2.0
    class HaveAttributeMatcher
      # @return [Symbol]
      # @private
      attr_reader :attribute_name

      # @return [String] Description
      # @private
      def description
        "have attribute named #{attribute_name}"
      end

      # @return [String] Failure message
      # @private
      def failure_message
        "Expected #{@model_class} to #{description}"
      end

      # @param [Symbol, String, #to_sym] attribute_name
      # @private
      def initialize(attribute_name)
        raise TypeError, "can't convert #{attribute_name.class} into Symbol" unless attribute_name.respond_to? :to_sym
        @attribute_name = attribute_name.to_sym
      end

      # @private
      def matches?(model_or_model_class)
        @model_class = class_from(model_or_model_class)

        @model_class.attributes.any? do |attribute|
          attribute.name == attribute_name
        end
      end

      # @return [String] Negative failure message
      # @private
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
