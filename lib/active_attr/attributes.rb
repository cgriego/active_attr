require 'active_support/concern'
require 'active_attr/attribute_definition'

module ActiveAttr
  module Attributes
    extend ActiveSupport::Concern

    def write_attribute(name, value)
      attributes[name.to_s] = value
    end

    def read_attribute(name)
      attributes[name.to_s]
    end

    def attributes
      @attributes ||= {}
    end

    def ==(other)
      return false unless other.instance_of?(self.class)
      attributes == other.attributes
    end

    module ClassMethods
      def attribute(name, opts={})
        attribute_definition = AttributeDefinition.new(name, opts)
        attributes << attribute_definition
        method_name = attribute_definition.name

        define_method("#{method_name}=") { |value| write_attribute(name, value) }
        define_method(method_name) { read_attribute(name) }
      end

      def attributes
        @attributes ||= []
      end

      def inspect
        "#{self.name}(#{attributes.map { |a| a.to_s }.join(', ')})"
      end
    end
  end
end
