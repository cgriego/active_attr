require 'active_support/concern'
require 'active_attr/attribute_definition'

module ActiveAttr
  module Attributes
    extend ActiveSupport::Concern

    module ClassMethods
      def attribute(name)
        attributes << AttributeDefinition.new(name)
      end

      def attributes
        @attributes ||= []
      end
    end
  end
end
