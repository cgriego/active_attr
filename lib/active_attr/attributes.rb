require "active_attr/attribute_definition"
require "active_support/concern"

module ActiveAttr
  # Attributes provides a set of class methods for defining an attributes schema.  Additionally,
  # implementations of
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::Attributes
  #     attribute :name
  #   end
  #
  #   person = Person.new
  #   person.name = "Ben Poweski"
  #
  # @since 0.2.0
  module Attributes
    extend ActiveSupport::Concern

    # Performs equality checking on the result of attributes and its type.
    #
    # @example Compare for equality.
    #   model == other
    #
    # @param [Attributes] other The other model to compare with.
    #
    # @return [true, false] True if attributes are equal and other is instance of the same Class, false if not.
    def ==(other)
      return false unless other.instance_of? self.class
      attributes == other.attributes
    end

    # Returns the raw attributes Hash
    #
    # @example Get attributes
    #   person.attributes # => {"name"=>"Ben Poweski"}
    #
    # @return [Hash] The Hash of attributes
    def attributes
      @attributes ||= {}
    end

    # Returns the class name plus its attributes
    #
    # @example Inspect the model.
    #   person.inspect
    #
    # @return [String] A nice pretty string to look at.
    def inspect
      attribute_descriptions = self.class.attributes.map do |attribute|
        "#{attribute.name.to_s}: #{read_attribute(attribute.name).inspect}"
      end

      "#<#{self.class.name} #{attribute_descriptions.join(", ")}>"
    end

    # Read a value from the model's attributes. If the value does not exist
    # it will return nil.
    #
    # @example Read an attribute.
    #   person.read_attribute(:name)
    #
    # @param [String, Symbol] name The name of the attribute to get.
    #
    # @return [Object] The value of the attribute.
    def read_attribute(name)
      attributes[name.to_s]
    end

    # Write a single attribute to the model's attribute hash.
    #
    # @example Write the attribute.
    #   person.write_attribute(:name, "Benjamin")
    #
    # @param [String, Symbol] name The name of the attribute to update.
    # @param [Object] value The value to set for the attribute.
    def write_attribute(name, value)
      attributes[name.to_s] = value
    end

    module ClassMethods #:nodoc:
      # Defines all the attributes that are to be returned from the attributes instance method.
      # For each attribute that is defined, a getter and setter will be
      # added as an instance method to the model. An AttributeDefinition instance will be
      # added to result of the attributes class method.
      #
      # @example Define an attribute.
      #   attribute :name, :type => String
      #
      # @param [Symbol] name The name of the attribute.
      # @param [Hash] options The options to pass to the attribute.
      #
      # @option options [Class] :type The type of the attribute.  A default of Object will be used unless given.
      def attribute(name, options={})
        attribute_definition = AttributeDefinition.new(name, options)
        attributes << attribute_definition
        method_name = attribute_definition.name

        define_method("#{method_name}=") { |value| write_attribute(name, value) }
        define_method(method_name) { read_attribute(name) }
      end

      # Returns an Array of AttributeDefinition instances
      #
      # @example Get attribute definitions
      #   Person.attributes
      #
      # @return [Array<AttributeDefinition>] The Array of AttributeDefinition instances
      def attributes
        @attributes ||= []
      end

      # Returns the class name plus its attribute definitions
      #
      # @example Inspect the model's definition.
      #   Person.inspect
      #
      # @return [String] A nice pretty string to look at.
      def inspect
        "#{self.name}(#{attributes.map { |a| a.to_s }.join(", ")})"
      end
    end
  end
end
