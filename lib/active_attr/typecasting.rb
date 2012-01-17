require "active_attr/typecasting/float_typecaster"
require "active_attr/typecasting/integer_typecaster"
require "active_attr/typecasting/string_typecaster"
require "active_support/concern"

module ActiveAttr
  # Typecasting provides methods to typecast a value to a different type
  #
  # @since 0.5.0
  module Typecasting
    extend ActiveSupport::Concern

    # @private
    TYPECASTERS = {
      Float    => FloatTypecaster,
      Integer  => IntegerTypecaster,
      String   => StringTypecaster,
    }

    # Typecasts a value using a Class
    #
    # @param [Class] type The type to cast to
    # @param [Object] value The value to be typecasted
    #
    # @return [Object, nil] The typecasted value or nil if it cannot be
    #   typecasted
    #
    # @since 0.5.0
    def typecast_attribute(type, value)
      raise ArgumentError, "a Class must be given" unless type
      return value unless requires_typecasting?(type, value)
      typecast_value(type, value)
    end

    # Determine if a value requires typecasting
    #
    # @example
    #   person = Person.new
    #   person.requires_typecasting?(Float, "1.0") #=> true
    #
    # @param [Class] The type
    # @param [Object] The value
    #
    # @return [true, false]
    #
    # @since 0.5.0
    def requires_typecasting?(type, value)
      !value.nil? && !value.kind_of?(type)
    end

    # Typecasts a value according to a predefined set of mapping rules defined
    #   in TYPECASTING_METHODS
    #
    # @param [Class] type The type to cast to
    # @param [Object] value The value to be typecasted
    #
    # @return [Object, nil] The result of a method call defined in
    #   TYPECASTING_METHODS, nil if no method is found
    #
    # @since 0.5.0
    def typecast_value(type, value)
      if typecaster = TYPECASTERS[type]
        typecaster.new.call(value)
      end
    end
  end
end
