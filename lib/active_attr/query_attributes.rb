require "active_attr/attributes"
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
    # Similar to an ActiveRecord model, when the attribute is a zero value or
    # is a string that represents false, the method returns false.
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
      case value = read_attribute(name)
      when "false", "FALSE", "f", "F" then false
      when Numeric, /^\-?[0-9]/ then !value.to_f.zero?
      else value.present?
      end
    end
  end
end
