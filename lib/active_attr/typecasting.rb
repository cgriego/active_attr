require "active_attr/typecasting/big_decimal_typecaster"
require "active_attr/typecasting/boolean"
require "active_attr/typecasting/boolean_typecaster"
require "active_attr/typecasting/date_time_typecaster"
require "active_attr/typecasting/date_typecaster"
require "active_attr/typecasting/float_typecaster"
require "active_attr/typecasting/integer_typecaster"
require "active_attr/typecasting/object_typecaster"
require "active_attr/typecasting/string_typecaster"
require "active_attr/multi_attr"
require "active_support/concern"

module ActiveAttr
  # Typecasting provides methods to typecast a value to a different type
  #
  # @since 0.5.0
  module Typecasting
    extend ActiveSupport::Concern

    # @private
    TYPECASTERS = {
      BigDecimal => BigDecimalTypecaster,
      Boolean    => BooleanTypecaster,
      Date       => DateTypecaster,
      DateTime   => DateTimeTypecaster,
      Float      => FloatTypecaster,
      Integer    => IntegerTypecaster,
      Object     => ObjectTypecaster,
      String     => StringTypecaster,
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
      return value if value.nil?
      typecast_value(type, value)
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
      if value.is_a?(ActiveAttr::MultiAttr)
        typecast_multiattr(type, value)
      elsif typecaster = TYPECASTERS[type]
        typecaster.new.call(value)
      end
    end

    def typecast_multiattr(klass, value)
      if klass == Time
        value.to_time
      elsif klass == Date
        value.to_date
      else
        values = (1..value.max_position).collect do |position|
          raise ActiveAttr::MultiAttr::MissingParameter if !value.has_key?(position)
          value[position]
        end
        klass.new(*values)
      end
    end
  end
end
