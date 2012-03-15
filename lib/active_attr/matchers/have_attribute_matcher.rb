module ActiveAttr
  module Matchers
    # Specify that a model should have an attribute matching the criteria. See
    # {HaveAttributeMatcher}
    #
    # @example Person should have a name attribute
    #   describe Person do
    #     it { should have_attribute(:first_name) }
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
    # given criteria. See {Matchers#have_attribute}
    #
    # @since 0.2.0
    class HaveAttributeMatcher
      attr_reader :attribute_name
      private :attribute_name

      # @return [String] Description
      # @private
      def description
        "has #{@description}"
      end

      # @return [String] Failure message
      # @private
      def failure_message
        if !includes_attributes?
          "expected #{@model_class.name} to include ActiveAttr::Attributes"
        elsif !includes_defaults?
          "expected #{@model_class.name} to include ActiveAttr::AttributeDefaults"
        elsif !includes_typecasting?
          "expected #{@model_class.name} to include ActiveAttr::TypecastedAttributes"
        else
          "expected #{@model_class.name} to have #{@description}"
        end
      end

      # @param [Symbol, String, #to_sym] attribute_name
      # @private
      def initialize(attribute_name)
        raise TypeError, "can't convert #{attribute_name.class} into Symbol" unless attribute_name.respond_to? :to_sym
        @attribute_name = attribute_name.to_sym
        @default_value_set = false
        @type = nil
        @description = "attribute named #{attribute_name}"
      end

      # Specify that the attribute should have the given type
      #
      # @example Person's first name should be a String
      #   describe Person do
      #     it { should have_attribute(:first_name).of_type(String) }
      #   end
      #
      # @param [Class] type The expected type
      #
      # @return [HaveAttributeMatcher] The matcher
      #
      # @since 0.5.0
      def of_type(type)
        @type = type
        @description << " of type #{type}"
        self
      end

      # @private
      def matches?(model_or_model_class)
        @model_class = class_from(model_or_model_class)

        return false if !includes_attributes? || !includes_defaults? || !includes_typecasting?

        @attribute_definition = @model_class.attributes[attribute_name]

        !!(@attribute_definition && default_matches? && type_matches?)
      end

      # @return [String] Negative failure message
      # @private
      def negative_failure_message
        "expected #{@model_class.name} to not have #{@description}"
      end

      # Specify that the attribute should have the given default value
      #
      # @example Person's first name should default to John
      #   describe Person do
      #     it do
      #       should have_attribute(:first_name).with_default_value_of("John")
      #     end
      #   end
      #
      # @param [Object] default_value The expected default value
      #
      # @return [HaveAttributeMatcher] The matcher
      #
      # @since 0.5.0
      def with_default_value_of(default_value)
        @default_value_set = true
        @default_value = default_value
        @description << " with a default value of #{default_value.inspect}"
        self
      end

      private

      def includes_attributes?
        model_ancestor_names.include?("ActiveAttr::Attributes")
      end

      def includes_defaults?
        !@default_value_set || model_ancestor_names.include?("ActiveAttr::AttributeDefaults")
      end

      def includes_typecasting?
        !@type || model_ancestor_names.include?("ActiveAttr::TypecastedAttributes")
      end

      def model_ancestor_names
        @model_class.ancestors.map(&:name)
      end

      def class_from(object)
        Class === object ? object : object.class
      end

      def default_matches?
        !@default_value_set || @attribute_definition[:default] == @default_value
      end

      def type_matches?
        !@type || @model_class._attribute_type(attribute_name) == @type
      end
    end
  end
end
