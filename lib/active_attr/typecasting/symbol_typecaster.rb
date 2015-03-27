module ActiveAttr
  module Typecasting
    # Typecasts an Object to a Symbol
    #
    # @example Usage
    #   SymbolTypecaster.new.call('a') #=> :a
    #
    # @since 0.13.1
    class SymbolTypecaster
      # Typecasts an object to a Symbol
      #
      # Attempts to convert using #to_sym.
      #
      # @example Typecast a String
      #   SymbolTypecaster.new.call('a') #=> :a
      #
      # @param [Object, #to_sym] value The object to typecast
      #
      # @return [Symbol, nil] The result of typecasting
      #
      # @since 0.13.1
      def call(value)
        value.to_sym if value.respond_to? :to_sym
      end
    end
  end
end
