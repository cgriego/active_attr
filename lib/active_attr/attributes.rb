require "active_attr/attribute_definition"
require "active_attr/dangerous_attribute_error"
require "active_attr/unknown_attribute_error"
require "active_model"
require "active_support/concern"
require "active_support/core_ext/class/attribute"
require "active_support/hash_with_indifferent_access"

begin
  require "active_support/parameter_filter"
rescue LoadError
  require "action_dispatch/http/parameter_filter"
end

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

    # @private
    # @since 0.14.0
    FILTERED = '[FILTERED]'.freeze

    # @private
    # @since 0.14.0
    PARAMETER_FILTER = if defined?(ActiveSupport::ParameterFilter)
      ActiveSupport::ParameterFilter
    else
      ActionDispatch::Http::ParameterFilter
    end

    # Specifies attributes which won't be exposed while calling #inspect
    #
    # @return [Array<#to_s, Regexp, Proc>] filter_attributes Configured
    # global default filtered attributes
    #
    # @since 0.14.0
    def self.filter_attributes
      @filter_attributes ||= []
    end

    # Configure the global default filtered attributes
    #
    # @param [Array<#to_s, Regexp, Proc>] new_filter_attributes The new
    # global default filtered attributes
    #
    # @since 0.14.0
    def self.filter_attributes=(new_filter_attributes)
      @filter_attributes = new_filter_attributes
    end

    included do
      class_attribute :filter_attributes, :instance_writer => false
      self.filter_attributes = Attributes.filter_attributes

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
      attributes_map { |name| send name }
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
      inspection_filter = PARAMETER_FILTER.new(filter_attributes)
      original_attributes = attributes
      filtered_attributes = inspection_filter.filter(original_attributes)

      attribute_descriptions = filtered_attributes.sort.map { |key, value|
        inspect_value = case
        when original_attributes[key].nil? then nil.inspect
        when value == FILTERED then FILTERED
        else value.inspect
        end

        "#{key}: #{inspect_value}"
      }.join(", ")

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

    # Maps all attributes using the given block
    #
    # @example Stringify attributes
    #   person.attributes_map { |name| send(name).to_s }
    #
    # @yield [name] block called to return hash value
    # @yieldparam [String] name The name of the attribute to map.
    #
    # @return [Hash{String => Object}] The Hash of mapped attributes
    #
    # @since 0.7.0
    def attributes_map
      self.class.attribute_names.each_with_object({}) do |name, hash|
        hash[name] = yield(name)
      end
    end

    module ClassMethods
      # Defines an attribute
      #
      # For each attribute that is defined, a getter and setter will be
      # added as an instance method to the model. An
      # {AttributeDefinition} instance will be added to result of the
      # attributes class method.
      #
      # @example Define an attribute.
      #   attribute :name
      #
      # @param (see AttributeDefinition#initialize)
      #
      # @raise [DangerousAttributeError] if the attribute name conflicts with
      #   existing methods
      #
      # @return [AttributeDefinition] Attribute's definition
      #
      # @since 0.2.0
      def attribute(name, options={})
        if dangerous_attribute_method_name = dangerous_attribute?(name)
          raise DangerousAttributeError, %{an attribute method named "#{dangerous_attribute_method_name}" would conflict with an existing method}
        else
          attribute! name, options
        end
      end

      # Defines an attribute without checking for conflicts
      #
      # Allows you to define an attribute whose methods will conflict
      # with an existing method. For example, Ruby's Timeout library
      # adds a timeout method to Object. Attempting to define a timeout
      # attribute using .attribute will raise a
      # {DangerousAttributeError}, but .attribute! will not.
      #
      # @example Define a dangerous attribute.
      #   attribute! :timeout
      #
      # @param (see AttributeDefinition#initialize)
      #
      # @return [AttributeDefinition] Attribute's definition
      #
      # @since 0.6.0
      def attribute!(name, options={})
        AttributeDefinition.new(name, options).tap do |attribute_definition|
          attribute_name = attribute_definition.name.to_s
          # Force active model to generate attribute methods
          remove_instance_variable("@attribute_methods_generated") if instance_variable_defined?("@attribute_methods_generated")
          define_attribute_methods([attribute_definition.name]) unless attribute_names.include? attribute_name
          remove_instance_variable("@attribute_names") if instance_variable_defined?("@attribute_names")
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
        @attribute_names ||= attributes.keys
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

      # Determine if a given attribute name is dangerous
      #
      # Some attribute names can cause conflicts with existing methods
      # on an object. For example, an attribute named "timeout" would
      # conflict with the timeout method that Ruby's Timeout library
      # mixes into Object.
      #
      # @example Testing a harmless attribute
      #   Person.dangerous_attribute? :name #=> false
      #
      # @example Testing a dangerous attribute
      #   Person.dangerous_attribute? :nil #=> "nil?"
      #
      # @param name Attribute name
      #
      # @return [false, String] False or the conflicting method name
      #
      # @since 0.6.0
      def dangerous_attribute?(name)
        attribute_methods(name).detect do |method_name|
          allocate.respond_to?(method_name, true)
        end unless attribute_names.include? name.to_s
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
        "#{name}#{attributes_list}"
      end

      protected

      # Assign a set of attribute definitions, used when subclassing models
      #
      # @param [Array<ActiveAttr::AttributeDefinition>] attributes The
      #   Array of AttributeDefinition instances
      #
      # @since 0.2.2
      def attributes=(attributes)
        @attributes = attributes
      end

      # Overrides ActiveModel::AttributeMethods to backport 3.2 fix
      def instance_method_already_implemented?(method_name)
        generated_attribute_methods.method_defined?(method_name)
      end

      private

      # Expand an attribute name into its generated methods names
      #
      # @since 0.6.0
      def attribute_methods(name)
        attribute_method_matchers.map { |matcher| matcher.method_name name }
      end

      # Because of this rename https://github.com/rails/rails/commit/251445601eb2e00bc15aacf261a85f919ab7f9de
      def attribute_method_matchers
        ActiveModel.version >= Gem::Version.new("7.1.a") ? attribute_method_patterns : super
      end

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
