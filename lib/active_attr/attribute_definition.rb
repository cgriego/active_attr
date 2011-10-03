module ActiveAttr
  # Represents an attribute
  #
  # @example Usage
  #   AttributeDefinition.new(:amount)
  #
  # @since 0.2.0
  class AttributeDefinition
    attr_reader :name

    # Performs equality checking of the attribute definition
    #
    # @example Compare for equality.
    #   attribute_definition == other
    #
    # @param [AttributeDefinition] other The other attribute definition to compare with.
    #
    # @return [true, false] True if attribute name is equal and other is instance of the same Class, false if not.
    def ==(attribute)
      return false unless attribute.instance_of? self.class
      name == attribute.name
    end

    # Creates a new AttributeDefinition
    #
    # @example Create an attribute defintion
    #   AttributeDefinition.new(:amount)
    #
    # @param [Symbol, String, #to_sym] attribute name
    #
    # @return [AttributeDefinition]
    def initialize(name, options={})
      raise TypeError, "can't convert #{name.class} into Symbol" unless name.respond_to? :to_sym
      @name = name.to_sym
    end

    # Returns the attribute name
    #
    # @return [String] the attribute name
    def to_s
      name.to_s
    end
  end
end
