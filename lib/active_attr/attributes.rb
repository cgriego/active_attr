require "active_attr/attribute_definition"
require "active_model"
require "active_support/concern"

module ActiveAttr
  # Attributes provides a set of class methods for defining an attributes
  # schema and instance methods for reading and writing attributes.
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
    include ActiveModel::AttributeMethods

    included do
      attribute_method_suffix ""
      attribute_method_suffix "="
    end

    # Performs equality checking on the result of attributes and its type.
    #
    # @example Compare for equality.
    #   model == other
    #
    # @param [ActiveAttr::Attributes, Object] other The other model to compare with.
    #
    # @return [true, false] True if attributes are equal and other is instance of the same Class, false if not.
    #
    # @since 0.2.0
    def ==(other)
      return false unless other.instance_of? self.class
      attributes == other.attributes
    end

    # Returns the raw attributes Hash
    #
    # @example Get attributes
    #   person.attributes # => {"name"=>"Ben Poweski"}
    #
    # @return [Hash] The Hash of all attributes
    #
    # @since 0.2.0
    def attributes
      attribute_names = self.class.attributes.map { |definition| definition.name.to_s }
      Hash[attribute_names.map { |key| [key, send(key)] }]
    end

    # @since 0.2.1
    def initialize(*args)
      @attributes ||= {}
      super
    end

    # Returns the class name plus its attributes
    #
    # @example Inspect the model.
    #   person.inspect
    #
    # @return [String] A nice pretty string to look at.
    #
    # @since 0.2.0
    def inspect
      attribute_descriptions = self.class.attributes.sort.map do |attribute|
        "#{attribute.name.to_s}: #{read_attribute(attribute.name).inspect}"
      end.join(", ")

      attribute_descriptions = " " + attribute_descriptions unless attribute_descriptions.empty?

      "#<#{self.class.name}#{attribute_descriptions}>"
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
    #
    # @since 0.2.0
    def read_attribute(name)
      @attributes[name.to_s]
    end
    alias_method :[], :read_attribute
    alias_method :attribute, :read_attribute
    private :attribute

    # Write a single attribute to the model's attribute hash.
    #
    # @example Write the attribute.
    #   person.write_attribute(:name, "Benjamin")
    #
    # @param [String, Symbol] name The name of the attribute to update.
    # @param [Object] value The value to set for the attribute.
    #
    # @since 0.2.0
    def write_attribute(name, value)
      @attributes[name.to_s] = value
    end
    alias_method :[]=, :write_attribute
    alias_method :attribute=, :write_attribute
    private :attribute=

    module ClassMethods
      # Defines all the attributes that are to be returned from the attributes instance method.
      # For each attribute that is defined, a getter and setter will be
      # added as an instance method to the model. An AttributeDefinition instance will be
      # added to result of the attributes class method.
      #
      # @example Define an attribute.
      #   attribute :name
      #
      # @param (see AttributeDefinition#initialize)
      #
      # @since 0.2.0
      def attribute(name, options={})
        AttributeDefinition.new(name, options).tap do |attribute_definition|
          attributes << attribute_definition
          define_attribute_method attribute_definition.name
        end
      end

      # Returns an Array of AttributeDefinition instances
      #
      # @example Get attribute definitions
      #   Person.attributes
      #
      # @return [Array<ActiveAttr::AttributeDefinition>] The Array of AttributeDefinition instances
      #
      # @since 0.2.0
      def attributes
        @attributes ||= []
      end

      # Returns the class name plus its attribute definitions
      #
      # @example Inspect the model's definition.
      #   Person.inspect
      #
      # @return [String] A nice pretty string to look at.
      #
      # @since 0.2.0
      def inspect
        inspected_attributes = attributes.sort.map { |attr| attr.inspect }
        attributes_list = "(#{inspected_attributes.join(", ")})" unless inspected_attributes.empty?
        "#{self.name}#{attributes_list}"
      end

      protected

      # Assign a set of attribute definitions, used when subclassing models
      #
      # @param [Array<ActiveAttr::AttributeDefinition>] The Array of AttributeDefinition instances
      #
      # @since 0.2.2
      def attributes=(attributes)
        @attributes = attributes
      end

      private

      # Ruby inherited hook to assign superclass attributes to subclasses
      #
      # @param [Class] subclass
      #
      # @since 0.2.2
      def inherited(subclass)
        super
        subclass.attributes = attributes.dup
      end
    end
  end
end
