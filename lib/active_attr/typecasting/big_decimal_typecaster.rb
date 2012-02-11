require "bigdecimal"
require "bigdecimal/util"

module ActiveAttr
  module Typecasting
    # TODO documentation
    class BigDecimalTypecaster
      # TODO documentation
      def call(value)
        case value
        when BigDecimal then value
        when Rational   then value.to_d
        else
          BigDecimal.new(value.to_s)
        end
      end
    end
  end
end
