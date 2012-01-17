module ActiveAttr
  module Typecasting
    class FloatTypecaster
      def call(value)
        value.to_f if value.respond_to? :to_f
      end
    end
  end
end
