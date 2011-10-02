require "active_attr/error"

module ActiveAttr
  # This exception is raised if attempting to mass assign unknown attributes
  # when using {StrictMassAssignment}
  #
  # @example Rescuing an UnknownAttributesError error
  #   begin
  #     Person.new(attributes)
  #   rescue ActiveAttr::UnknownAttributesError
  #     Person.new
  #   end
  class UnknownAttributesError < NoMethodError
    include Error
  end
end
