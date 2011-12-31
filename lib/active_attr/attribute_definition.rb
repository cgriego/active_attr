require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/string/inflections'

module ActiveAttr
  # Represents an attribute for reflection
  #
  # @example Usage
  #   AttributeDefinition.new(:amount)
  #
  # @since 0.2.0
  class AttributeDefinition
    include Comparable

    # The attribute name
    # @since 0.2.0
    attr_reader :name

    # Compare attribute definitions
    #
    # @example
    #   attribute_definition <=> other
    #
    # @param [ActiveAttr::AttributeDefinition, Object] other The other
    #   attribute definition to compare with.
    #
    # @return [-1, 0, 1, nil]
    #
    # @since 0.2.1
    def <=>(other)
      return nil unless other.instance_of? self.class
      return nil if name == other.name && options != other.options
      self.name.to_s <=> other.name.to_s
    end

    # Read an attribute option
    #
    # @example
    #   attribute_definition[:type]
    #
    # @param [Symbol] key The option key
    #
    # @since 0.5.0
    def [](key)
      @options[key]
    end

    # Creates a new AttributeDefinition
    #
    # @example Create an attribute defintion
    #   AttributeDefinition.new(:amount)
    #
    # @param [Symbol, String, #to_sym] name attribute name
    #
    # @return [ActiveAttr::AttributeDefinition]
    #
    # @since 0.2.0
    def initialize(name, options={})
      raise TypeError, "can't convert #{name.class} into Symbol" unless name.respond_to? :to_sym
      @name = name.to_sym
      @options = options
    end

    # The attribute name
    #
    # @return [String] the attribute name
    #
    # @since 0.2.0
    def to_s
      name.to_s
    end

    # The attribute name
    #
    # @return [Symbol] the attribute name
    #
    # @since 0.2.1
    def to_sym
      name
    end

    protected

    # The attribute options
    # @since 0.5.0
    attr_reader :options
  end
end
