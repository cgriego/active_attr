require "active_support/core_ext/string/conversions"
require "active_support/time"

module ActiveAttr
  module Typecasting
    # TODO documentation
    class DateTypecaster
      # TODO documentation
      def call(value)
        value.to_date if value.respond_to? :to_date
      end
    end
  end
end
