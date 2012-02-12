require "bigdecimal"
require "bigdecimal/util"
require "active_support/core_ext/big_decimal/conversions"

module ActiveAttr
  module Typecasting
    # TODO documentation
    class BigDecimalTypecaster
      # TODO documentation
      def call(value)
        if value.respond_to? :to_d
          value.to_d
        else
          BigDecimal.new value.to_s
        end
      end
    end
  end
end
