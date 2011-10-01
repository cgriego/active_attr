module ActiveAttr
  class AttributeDefinition
    attr_reader :name, :type

    def ==(attribute)
      return false unless attribute.instance_of? self.class
      name == attribute.name && type == attribute.type
    end

    def to_s
      [name, type].join(': ')
    end

    def initialize(name, options={})
      raise TypeError, "can't convert #{name.class} into Symbol" unless name.respond_to? :to_sym
      @name = name.to_sym
      @type = options[:type] || Object
    end
  end
end
