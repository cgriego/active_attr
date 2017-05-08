require 'json'

module ActiveAttr
  module Typecasting
    # Typecasts an Object to an Array
    #
    # @example Usage
    #   ArrayTypecaster.new.call(1) # => [1]
    #
    # @since 0.6.0
    class ArrayTypecaster
      # Typecasts an Object to an Array
      #
      # Will typecast any Object except nil to an Array, first by attempting to
      # call `#to_a`, then by wrapping `value` in an Array (`[value]`).
      #
      # @example Usage
      #   ArrayTypecaster.new.call(1) # => [1]
      #
      # @param [Object] value The object to typecast
      #
      # @return [Array, nil] The result of typecasting
      #
      # @since 0.6.0
      def call(value)
        #treat incoming strings as serialized JSON
        value = JSON::parse(value) if value.is_a? String

        if value.respond_to? :to_a
          value.to_a
        elsif value.nil?
          value
        else
          [value]
        end
      end
    end
  end
end
    
