require "active_attr/error"

module ActiveAttr
  # This exception is raised if attempting to assign unknown attributes when
  # using {Attributes}
  #
  # @example Rescuing an UnknownAttributeError error
  #   begin
  #     person.write_attribute(:middle_initial, "J")
  #   rescue ActiveAttr::UnknownAttributeError
  #     logger.error "attempted to write an unknown attribute"
  #     raise
  #   end
  #
  # @since 0.3.0
  class UnknownAttributeError < NoMethodError
    include Error
  end
end
