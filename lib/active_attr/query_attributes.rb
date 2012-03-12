require "active_attr/attributes"
require "active_attr/typecasting"
require "active_attr/unknown_attribute_error"
require "active_support/concern"
require "active_support/core_ext/object/blank"

module ActiveAttr
  # QueryAttributes provides instance methods for querying attributes.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::QueryAttributes
  #     attribute :name
  #   end
  #
  #   person = Person.new
  #   person.name? #=> false
  #   person.name = "Chris Griego"
  #   person.name? #=> true
  #
  # @since 0.3.0
  module QueryAttributes
    extend ActiveSupport::Concern
    include Attributes

    included do
      attribute_method_suffix "?"
    end

    # Test the presence of an attribute
    #
    # See {Typecasting::BooleanTypecaster#call} for more details.
    #
    # @example Query an attribute
    #   person.query_attribute(:name)
    #
    # @param [String, Symbol, #to_s] name The name of the attribute to query
    #
    # @return [true, false] The presence of the attribute
    #
    # @raise [UnknownAttributeError] if the attribute is unknown
    #
    # @since 0.3.0
    def query_attribute(name)
      if respond_to? "#{name}?"
        send "#{name}?"
      else
        raise UnknownAttributeError, "unknown attribute: #{name}"
      end
    end

    private

    def attribute?(name)
      Typecasting::BooleanTypecaster.new.call(read_attribute(name))
    end
  end
end
