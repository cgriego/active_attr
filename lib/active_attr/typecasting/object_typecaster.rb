module ActiveAttr
  module Typecasting
    # A typecaster that does nothing as anything passed is already an object.
    #
    # @example Usage
    #   ObjectTypecaster.new.call("") #=> ""
    #
    # @since 0.5.0
    class ObjectTypecaster
      # Typecasts an object to an object
      #
      # @example Typecast an Object
      #   typecaster.call(1)  #=> 1
      #
      # @param [Object] value The object to typecast
      #
      # @return [Object] Whatever you passed in
      #
      # @since 0.5.0
      def call(value)
        value
      end
    end
  end
end
