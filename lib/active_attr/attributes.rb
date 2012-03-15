require "active_attr/attribute_definition"
require "active_attr/dangerous_attribute_error"
require "active_attr/unknown_attribute_error"
require "active_model"
require "active_support/concern"
require "active_support/hash_with_indifferent_access"
require "active_attr/inheritable_attributes_fix"

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

    # Methods deprecated on the Object class which can be safely overridden
    # @since 0.3.0
    DEPRECATED_OBJECT_METHODS = %w(id type)

    included do
      attribute_method_suffix "" if attribute_method_matchers.none? { |matcher| matcher.prefix == "" && matcher.suffix == "" }
      attribute_method_suffix "="
    end

    # Performs equality checking on the result of attributes and its type.
    #
    # @example Compare for equality.
    #   model == other
    #
    # @param [ActiveAttr::Attributes, Object] other The other model to compare
    #
    # @return [true, false] True if attributes are equal and other is instance
    #   of the same Class, false if not.
    #
    # @since 0.2.0
    def ==(other)
      return false unless other.instance_of? self.class
      attributes == other.attributes
    end

    # Returns a Hash of all attributes
    #
    # @example Get attributes
    #   person.attributes # => {"name"=>"Ben Poweski"}
    #
    # @return [Hash{String => Object}] The Hash of all attributes
    #
    # @since 0.2.0
    def attributes
      Hash[self.class.attribute_names.map { |key| [key, send(key)] }]
    end

    # Returns the class name plus its attributes
    #
    # @example Inspect the model.
    #   person.inspect
    #
    # @return [String] Human-readable presentation of the attribute
    #   definitions
    #
    # @since 0.2.0
    def inspect
      attribute_descriptions = attributes.sort.map { |key, value| "#{key}: #{value.inspect}" }.join(", ")
      separator = " " unless attribute_descriptions.empty?
      "#<#{self.class.name}#{separator}#{attribute_descriptions}>"
    end

    # Read a value from the model's attributes.
    #
    # @example Read an attribute with read_attribute
    #   person.read_attribute(:name)
    # @example Rean an attribute with bracket syntax
    #   person[:name]
    #
    # @param [String, Symbol, #to_s] name The name of the attribute to get.
    #
    # @return [Object] The value of the attribute.
    #
    # @raise [UnknownAttributeError] if the attribute is unknown
    #
    # @since 0.2.0
    def read_attribute(name)
      if respond_to? name
        send name.to_s
      else
        raise UnknownAttributeError, "unknown attribute: #{name}"
      end
    end
    alias_method :[], :read_attribute

    # Write a single attribute to the model's attribute hash.
    #
    # @example Write the attribute with write_attribute
    #   person.write_attribute(:name, "Benjamin")
    # @example Write an attribute with bracket syntax
    #   person[:name] = "Benjamin"
    #
    # @param [String, Symbol, #to_s] name The name of the attribute to update.
    # @param [Object] value The value to set for the attribute.
    #
    # @raise [UnknownAttributeError] if the attribute is unknown
    #
    # @since 0.2.0
    def write_attribute(name, value)
      if respond_to? "#{name}="
        send "#{name}=", value
      else
        raise UnknownAttributeError, "unknown attribute: #{name}"
      end
    end
    alias_method :[]=, :write_attribute

    protected

    # Overrides ActiveModel::AttributeMethods
    # @private
    def attribute_method?(attr_name)
      self.class.attribute_names.include? attr_name.to_s
    end

    private

    # Read an attribute from the attributes hash
    #
    # @since 0.2.1
    def attribute(name)
      @attributes ||= {}
      @attributes[name]
    end

    # Write an attribute to the attributes hash
    #
    # @since 0.2.1
    def attribute=(name, value)
      @attributes ||= {}
      @attributes[name] = value
    end

    module ClassMethods
      # Defines an attribute
      #
      # For each attribute that is defined, a getter and setter will be
      # added as an instance method to the model. An AttributeDefinition
      # instance will be added to result of the attributes class method.
      #
      # @example Define an attribute.
      #   attribute :name
      #
      # @param (see AttributeDefinition#initialize)
      #
      # @raise [DangerousAttributeError] if the attribute name conflicts with
      #   existing methods
      #
      # @since 0.2.0
      def attribute(name, options={})
        AttributeDefinition.new(name, options).tap do |attribute_definition|
          attribute_name = attribute_definition.name.to_s
          # Force active model to generate attribute methods
          @attribute_methods_generated = false
          define_attribute_methods([attribute_definition.name]) unless attribute_names.include? attribute_name
          attributes[attribute_name] = attribute_definition
        end
      end

      # Returns an Array of attribute names as Strings
      #
      # @example Get attribute names
      #   Person.attribute_names
      #
      # @return [Array<String>] The attribute names
      #
      # @since 0.5.0
      def attribute_names
        attributes.keys
      end

      # Returns a Hash of AttributeDefinition instances
      #
      # @example Get attribute definitions
      #   Person.attributes
      #
      # @return [ActiveSupport::HashWithIndifferentAccess{String => ActiveAttr::AttributeDefinition}]
      #   The Hash of AttributeDefinition instances
      #
      # @since 0.2.0
      def attributes
        @attributes ||= ActiveSupport::HashWithIndifferentAccess.new
      end

      # Returns the class name plus its attribute names
      #
      # @example Inspect the model's definition.
      #   Person.inspect
      #
      # @return [String] Human-readable presentation of the attributes
      #
      # @since 0.2.0
      def inspect
        inspected_attributes = attribute_names.sort
        attributes_list = "(#{inspected_attributes.join(", ")})" unless inspected_attributes.empty?
        "#{self.name}#{attributes_list}"
      end

      protected

      # Assign a set of attribute definitions, used when subclassing models
      #
      # @param [Array<ActiveAttr::AttributeDefinition>] The Array of
      #   AttributeDefinition instances
      #
      # @since 0.2.2
      def attributes=(attributes)
        @attributes = attributes
      end

      # Overrides ActiveModel::AttributeMethods
      # @private
      def instance_method_already_implemented?(method_name)
        deprecated_object_method = DEPRECATED_OBJECT_METHODS.include?(method_name.to_s)
        already_implemented = !deprecated_object_method && self.allocate.respond_to?(method_name, true)
        raise DangerousAttributeError, %{an attribute method named "#{method_name}" would conflict with an existing method} if already_implemented
        false
      end

      private

      # Ruby inherited hook to assign superclass attributes to subclasses
      #
      # @since 0.2.2
      def inherited(subclass)
        super
        subclass.attributes = attributes.dup
      end
    end
  end
end
