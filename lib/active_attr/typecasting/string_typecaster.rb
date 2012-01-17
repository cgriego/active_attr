module ActiveAttr
  module Typecasting
    class StringTypecaster
      def call(value)
        value.to_s if value.respond_to? :to_s
      end
    end
  end
end
