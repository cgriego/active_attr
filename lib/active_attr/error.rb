module ActiveAttr
  # All exceptions raised directly by ActiveAttr include this module, if you
  # want to rescue any of the exceptions raised by the ActiveAttr library, you
  # can rescue {ActiveAttr::Error}
  #
  # @example Rescuing an ActiveAttr error
  #   begin
  #     Person.new(attributes)
  #   rescue ActiveAttr::Error
  #     Person.new
  #   end
  module Error
  end
end
