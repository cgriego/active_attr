module ActiveAttr
  module Typecasting
    class IntegerTypecaster
      def call(value)
        value.to_i if value.respond_to? :to_i
      rescue FloatDomainError
      end
    end
  end
end
