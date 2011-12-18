require "active_support/concern"

module ActiveAttr
  # Typecasting provides methods to typecast a value to a different type
  #
  # @since 0.5.0
  module Typecasting
    extend ActiveSupport::Concern

    TYPECASTING_METHODS = {
      Array    => :to_a,
      Date     => :to_date,
      DateTime => :to_datetime,
      Float    => :to_f,
      Integer  => :to_i,
      String   => :to_s,
      Time     => :to_time,
    }

    # Typecasts a value using a Class
    #
    # It first tries to typecast the value using the #custom_typecasting_value
    # method. If that returns nothing. It next tries to convert the value
    # using #typecast_value, if nothing is return the original value is
    # returned.
    #
    # @param [Class] type The type to cast to
    # @param [Object] value The value to be typecasted
    #
    # @return [Object] The typecasted value or the original value if
    #   typecasting was not applied
    #
    # @since 0.5.0
    def typecast_attribute(type, value)
      raise ArgumentError, "a Class must be given" unless type
      return value unless requires_typecasting?(type, value)
      custom_typecast_value(type, value) || typecast_value(type, value) || value
    end

    # Attempt to typecast a value using a custom contum typecasting method
    #
    # If the value responds to a method custom typecasting method in the form
    # of #typecast_to_<type> then the value result of that method is returned,
    # otherwise nil is returned.
    #
    # @param [Class] type The type to cast to
    # @param [Object] value The value to be typecasted
    #
    # @return [Object, nil] The result of the custom typecasting method on the
    #   value, nil if no method exists
    #
    # @since 0.5.0
    def custom_typecast_value(type, value)
      converstion_method_name = "typecast_to_#{type.to_s.downcase}"
      value.send(converstion_method_name) if value.respond_to?(converstion_method_name)
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
    end
  end
end
