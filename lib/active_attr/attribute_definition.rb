module ActiveAttr
  class AttributeDefinition
    attr_reader :name

    def initialize(name)
      raise TypeError, "expected #{name} to be a Symbol or String" unless name.respond_to?(:to_sym)
      @name = name.to_sym
    end

    def ==(attribute)
      return false unless attribute.instance_of?(self.class)
      name == attribute.name
    end
  end
end