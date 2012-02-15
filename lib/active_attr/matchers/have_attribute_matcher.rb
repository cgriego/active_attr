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
      attr_reader :attribute_name, :default_value
      private :attribute_name, :default_value

      # Specify that the attribute should have the given default value
      #
      # @example Person's first name should default to John
      #   describe Person do
      #     it do
      #       should have_attribute(:first_name).with_default_value_of("John")
      #     end
      #   end
      #
      # @param [Object]
      #
      # @since 0.5.0
      def with_default_value_of(default_value)
        @default_value_set = true
        @default_value = default_value
        self
      end

      # @return [String] Description
      # @private
      def description
        "have attribute named #{attribute_name}#{ " with a default value of #{default_value.inspect}" if @default_value_set}"
      end

      # @return [String] Failure message
      # @private
      def failure_message
        "Expected #{@model_class.name} to #{description}"
      end

      # @param [Symbol, String, #to_sym] attribute_name
      # @private
      def initialize(attribute_name)
        raise TypeError, "can't convert #{attribute_name.class} into Symbol" unless attribute_name.respond_to? :to_sym
        @attribute_name = attribute_name.to_sym
        @default_value_set = false
      end

      # @private
      def matches?(model_or_model_class)
        @model_class = class_from(model_or_model_class)
        @attribute_definition = @model_class.attributes[attribute_name]

        !!(@attribute_definition && (!@default_value_set || @attribute_definition[:default] == default_value))
      end

      # @return [String] Negative failure message
      # @private
      def negative_failure_message
        "Expected #{@model_class.name} to not #{description}"
      end

      private

      def class_from(object)
        Class === object ? object : object.class
      end
    end
  end
end
