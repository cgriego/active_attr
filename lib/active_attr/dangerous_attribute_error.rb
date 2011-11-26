require "active_attr/error"

module ActiveAttr
  # This exception is raised if attempting to define an attribute whose name
  # conflicts with methods that are already defined
  #
  # @since 0.3.0
  class DangerousAttributeError < ScriptError
    include Error
  end
end
