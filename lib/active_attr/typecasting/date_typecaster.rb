require "date"
require "active_support/core_ext/date/conversions"
require "active_support/core_ext/date_time/conversions"
require "active_support/core_ext/string/conversions"
require "active_support/core_ext/time/publicize_conversion_methods"

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
