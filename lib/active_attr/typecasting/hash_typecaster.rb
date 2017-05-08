require 'json'

module ActiveAttr
  module Typecasting
    # Typecasts an Object to an Array
    #
    # @example Usage
    #   ArrayTypecaster.new.call(1) # => [1]
    #
    # @since 0.6.0
    class HashTypecaster
      # Typecasts an Object to a Hash
      #
      # Will typecast JSON or Hashes into a Hash
      #
      # @example Usage
      #   HashTypecaster.new.call(nil) # => {}
      #   HashTypecaster.new.call({:x => :y}) # => {:x => :y}
      #   HashTypecaster.new.call({:x => :y}.to_json) # => {:x => :y}
      #
      # @param [Object] value The object to typecast
      #
      # @return [Hash, nil] The result of typecasting
      #
      # @since 0.6.0
      def call(value)
        #treat incoming strings as serialized JSON
        value = JSON::parse(value) if value.is_a? String
        value.is_a?(Hash) ? value : {}
      end
    end
  end
end
