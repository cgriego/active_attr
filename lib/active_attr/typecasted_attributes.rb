require "active_attr/attributes"
require "active_attr/typecasting"
require "active_support/concern"

module ActiveAttr
  # TypecastedAttributes enhances attribute handling with typecasting
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::TypecastedAttributes
  #     attribute :name
  #     attribute :age, :type => Integer
  #   end
  #
  #   person = Person.new
  #   person.name = "Ben Poweski"
  #   person.age  = "29"
  #
  #   person.age #=> 29
  #
  # @since 0.5.0
  module TypecastedAttributes
    extend ActiveSupport::Concern
    include Attributes
    include Typecasting

    private

    # Reads the attribute and typecasts the result
    #
    # @since 0.5.0
    def attribute(name)
      typecast_attribute(_attribute_type(name), super)
    end

    # Calculates an attribute type
    #
    # @private
    # @since 0.5.0
    def _attribute_type(attribute_name)
      self.class._attribute_type(attribute_name)
    end

    module ClassMethods
      # Returns the class name plus its attribute names and types
      #
      # @example Inspect the model's definition.
      #   Person.inspect
      #
      # @return [String] Human-readable presentation of the attributes
      #
      # @since 0.5.0
      def inspect
        inspected_attributes = attribute_names.map { |name| "#{name}: #{_attribute_type(name)}" }
        attributes_list = "(#{inspected_attributes.join(", ")})" unless inspected_attributes.empty?
        "#{self.name}#{attributes_list}"
      end

      # Calculates an attribute type
      #
      # @private
      # @since 0.5.0
      def _attribute_type(attribute_name)
        attributes[attribute_name][:type] || Object
      end
    end
  end
end
