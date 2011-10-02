require "active_support/concern"
require "active_attr/attribute_definition"

module ActiveAttr
  module Attributes
    extend ActiveSupport::Concern

    def ==(other)
      return false unless other.instance_of? self.class
      attributes == other.attributes
    end

    def attributes
      @attributes ||= {}
    end

    def inspect
      attribute_descriptions = self.class.attributes.map do |attribute|
        "#{attribute.name.to_s}: #{read_attribute(attribute.name).inspect}"
      end

      "#<#{self.class.name} #{attribute_descriptions.join(", ")}>"
    end

    def read_attribute(name)
      attributes[name.to_s]
    end

    def write_attribute(name, value)
      attributes[name.to_s] = value
    end

    module ClassMethods
      def attribute(name, options={})
        attribute_definition = AttributeDefinition.new(name, options)
        attributes << attribute_definition
        method_name = attribute_definition.name

        define_method("#{method_name}=") { |value| write_attribute(name, value) }
        define_method(method_name) { read_attribute(name) }
      end

      def attributes
        @attributes ||= []
      end

      def inspect
        "#{self.name}(#{attributes.map { |a| a.to_s }.join(", ")})"
      end
    end
  end
end
