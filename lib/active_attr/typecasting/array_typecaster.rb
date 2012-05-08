module ActiveAttr
  module Typecasting
    class ArrayTypecaster
      # Typecasts an Object to an nArray
      #
      # @example Usage
      #   ArrayTypecaster.new.call([1]) # => [1]
      #
      # @return [Array, nil] The result of typecasting
      #
      # @since #TODO: What is the current version?
      def call(value)
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
    
