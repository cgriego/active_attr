require "active_support/core_ext/object/blank"

module ActiveAttr
  module Typecasting
    # TODO documentation
    class BooleanTypecaster
      # TODO documentation
      # http://yaml.org/type/bool.html
      FALSE_VALUES = ["n", "N", "no", "No", "NO", "false", "False", "FALSE", "off", "Off", "OFF", "f", "F"]

      # TODO documentation
      def call(value)
        case value
        when *FALSE_VALUES then false
        when Numeric, /^\-?[0-9]/ then !value.to_f.zero?
        else value.present?
        end
      end
    end
  end
end
