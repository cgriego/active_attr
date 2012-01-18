module ActiveAttr
  module Typecasting
    # TODO documentation
    class StringTypecaster
      # TODO documentation
      def call(value)
        value.to_s if value.respond_to? :to_s
      end
    end
  end
end
