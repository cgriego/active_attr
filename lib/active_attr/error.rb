module ActiveAttr
  # All exceptions defined by and raised directly by ActiveAttr include this
  # module, if you want to rescue any of the exceptions raised by the
  # ActiveAttr library, you can rescue {ActiveAttr::Error}
  #
  # @example Rescuing an ActiveAttr error
  #   begin
  #     Person.new(attributes)
  #   rescue ActiveAttr::Error
  #     Person.new
  #   end
  #
  # @since 0.2.0
  module Error
  end
end
