module ActiveAttr
  module Typecasting
    # TODO documentation
    class FloatTypecaster
      # TODO documentation
      def call(value)
        value.to_f if value.respond_to? :to_f
      end
    end
  end
end
