module ActiveAttr
  class AttributeDefinition
    attr_reader :name, :type

    def initialize(name, opts={})
      raise TypeError, "expected #{name} to be a Symbol or String" unless name.respond_to?(:to_sym)
      @name = name.to_sym
      @type = opts[:type] || Object
    end

    def ==(attribute)
      return false unless attribute.instance_of?(self.class)
      name == attribute.name && type == attribute.type
    end

    def to_s
      [name, type].join(': ')
    end
  end
end