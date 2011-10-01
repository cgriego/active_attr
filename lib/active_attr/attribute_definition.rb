module ActiveAttr
  class AttributeDefinition
    attr_reader :name

    def ==(attribute)
      return false unless attribute.instance_of? self.class
      name == attribute.name
    end

    def initialize(name)
      raise TypeError, "can't convert #{name.class} into Symbol" unless name.respond_to? :to_sym
      @name = name.to_sym
    end
  end
end
