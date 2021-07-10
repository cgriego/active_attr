module ActiveAttr
  class UUID
  end

  module Typecasting
    # Typecasts an Object to a v4 UUID
    #
    # @example Usage
    #   UUIDTypecaster.new.call("6ed806a8-60ec-4930-ae63-9075bf37ca41") #=> "6ed806a8-60ec-4930-ae63-9075bf37ca41"
    #   UUIDTypecaster.new.call("6ed806a8-60ec") #=> nil
    #
    # @since 0.15.0
    class UUIDTypecaster
      # Typecasts an object to a v4 UUID
      #
      # Attempts to convert using SecureRandom
      #
      # @example Typecast a partial UUID
      #   typecaster.call("6ed806a8-60ec") #=> nil
      #
      # @param [Object, #to_s] value The object to typecast
      #
      # @return [String, nil] The result of typecasting
      #
      # @since 0.5.0
      def call(value)
        regex = /\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b/
        value.to_s.match?(regex) ? value : nil
      end
    end
  end
end
