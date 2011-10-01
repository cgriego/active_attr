require "active_support/dependencies/autoload"

module ActiveAttr
  extend ActiveSupport::Autoload

  autoload :AttributeDefinition
  autoload :Attributes
  autoload :MassAssignment
  autoload :VERSION
end
