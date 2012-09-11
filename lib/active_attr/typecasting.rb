require "active_attr/typecasting/big_decimal_typecaster"
require "active_attr/typecasting/boolean"
require "active_attr/typecasting/boolean_typecaster"
require "active_attr/typecasting/date_time_typecaster"
require "active_attr/typecasting/date_typecaster"
require "active_attr/typecasting/float_typecaster"
require "active_attr/typecasting/integer_typecaster"
require "active_attr/typecasting/object_typecaster"
require "active_attr/typecasting/string_typecaster"
require "active_attr/typecasting/unknown_typecaster_error"

module ActiveAttr
  # Typecasting provides methods to typecast a value to a different type
  #
  # The following types are supported for typecasting:
  # * BigDecimal
  # * Boolean
  # * Date
  # * DateTime
  # * Float
  # * Integer
  # * Object
  # * String
  #
  # @since 0.5.0
  module Typecasting
    # Typecasts a value using a Class
    #
    # @param [#call] typecaster The typecaster to use for typecasting
    # @param [Object] value The value to be typecasted
    #
    # @return [Object, nil] The typecasted value or nil if it cannot be
    #   typecasted
    #
    # @since 0.5.0
    def typecast_attribute(typecaster, value)
      raise ArgumentError, "a typecaster must be given" unless typecaster.respond_to?(:call)
      return value if value.nil?
      typecaster.call(value)
    end

    # Resolve a Class to a typecaster
    #
    # @param [Class] type The type to cast to
    #
    # @return [#call, nil] The typecaster to use
    #
    # @since 0.6.0
    def typecaster_for(type)
      case
      when type == BigDecimal then BigDecimalTypecaster.new
      when type == Boolean    then BooleanTypecaster.new
      when type == Date       then DateTypecaster.new
      when type == DateTime   then DateTimeTypecaster.new
      when type == Float      then FloatTypecaster.new
      when type == Integer    then IntegerTypecaster.new
      when type == Object     then ObjectTypecaster.new
      when type == String     then StringTypecaster.new
      end
    end
  end
end
