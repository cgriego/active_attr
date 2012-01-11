require "active_support/concern"

module ActiveAttr
  # Typecasting provides methods to typecast a value to a different type
  #
  # @since 0.5.0
  module Typecasting
    extend ActiveSupport::Concern

    # A Hash with keys of types and values of their conversion method.
    #
    # @example converting to a Time
    #   TYPECASTING_METHODS[Time] #-> :to_time
    #
    # @since 0.5.0
    TYPECASTING_METHODS = {
      Date     => :to_date,
      DateTime => :to_datetime,
      Float    => :to_f,
      Integer  => :to_i,
      String   => :to_s,
      Time     => :to_time,
    }

    # Typecasts a value using a Class
    #
    # @param [Class] type The type to cast to
    # @param [Object] value The value to be typecasted
    #
    # @return [Object, nil] The typecasted value or nil if it cannot be
    #   typecasted
    #
    # @since 0.5.0
    def typecast_attribute(type, value)
      raise ArgumentError, "a Class must be given" unless type
      return value unless requires_typecasting?(type, value)
      typecast_value(type, value)
    end

    # Determine if a value requires typecasting
    #
    # @example
    #   person = Person.new
    #   person.requires_typecasting?(Float, "1.0") #=> true
    #
    # @param [Class] The type
    # @param [Object] The value
    #
    # @return [true, false]
    #
    # @since 0.5.0
    def requires_typecasting?(type, value)
      !value.kind_of?(type)
    end

    # Typecasts a value according to a predefined set of mapping rules defined
    #   in TYPECASTING_METHODS
    #
    # @param [Class] type The type to cast to
    # @param [Object] value The value to be typecasted
    #
    # @return [Object, nil] The result of a method call defined in
    #   TYPECASTING_METHODS, nil if no method is found
    #
    # @since 0.5.0
    def typecast_value(type, value)
      if method = TYPECASTING_METHODS[type]
        value.send(method) if value.respond_to?(method)
      end
    rescue FloatDomainError
    end
  end
end
