require "active_support/core_ext/object/blank"

module ActiveAttr
  module Typecasting
    # Typecasts an Object to true or false
    #
    # @example Usage
    #   BooleanTypecaster.new.call(1) #=> true
    #
    # @since 0.5.0
    class BooleanTypecaster
      # Values which force a false result for typecasting
      #
      # These values are based on the
      # {YAML language}[http://yaml.org/type/bool.html].
      #
      # @since 0.5.0
      FALSE_VALUES = ["n", "N", "no", "No", "NO", "false", "False", "FALSE", "off", "Off", "OFF", "f", "F"]

      # Values which force a nil result for typecasting
      #
      # These values are based on the behavior of ActiveRecord
      #
      # @since 0.14.0
      NIL_VALUES = ["", nil]

      # Typecasts an object to true or false
      #
      # Similar to ActiveRecord, when the attribute is a zero value or
      # is a string that represents false, typecasting returns false.
      # Otherwise typecasting just checks the presence of a value.
      #
      # @example Typecast an Integer
      #   typecaster.call(1) #=> true
      #
      # @param [Object] value The object to typecast
      #
      # @return [true, false] The result of typecasting
      #
      # @since 0.5.0
      def call(value)
        case value
        when *FALSE_VALUES then false
        when *NIL_VALUES then nil
        when Numeric, /\A[-+]?(0+\.?0*|0*\.?0+)\z/ then !value.to_f.zero?
        else value.present?
        end
      end
    end
  end
end
