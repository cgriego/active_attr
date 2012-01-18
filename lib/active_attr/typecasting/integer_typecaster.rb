module ActiveAttr
  module Typecasting
    # TODO documentation
    class IntegerTypecaster
      # TODO documentation
      def call(value)
        value.to_i if value.respond_to? :to_i
      rescue FloatDomainError
      end
    end
  end
end
