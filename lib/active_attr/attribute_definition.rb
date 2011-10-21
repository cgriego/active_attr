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
    # @param [ActiveAttr::AttributeDefinition, Object] other The other attribute definition to compare with.
    #
    # @return [-1, 0, 1, nil]
    #
    # @since 0.2.1
    def <=>(other)
      return nil unless other.instance_of? self.class
      self.name.to_s <=> other.name.to_s
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
    end

    # The attribute name
    #
    # @return [String] the attribute name
    #
    # @since 0.2.0
    def to_s
      name.to_s
    end
    alias_method :inspect, :to_s

    # The attribute name
    #
    # @return [Symbol] the attribute name
    #
    # @since 0.2.1
    def to_sym
      name
    end
  end
end
