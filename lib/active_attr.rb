require "active_support/dependencies/autoload"

# ActiveAttr is a set of modules to enhance Plain Old Ruby Objects (POROs)
#
# These modules give your objects the type of features that are normally found
# in popular Object Relation Mappers (ORMs) like ActiveRecord, DataMapper, and
# Mongoid. The goal is to lower the bar for creating easy-to-use Ruby models.
module ActiveAttr
  extend ActiveSupport::Autoload

  autoload :AttributeDefinition
  autoload :Attributes
  autoload :BasicModel
  autoload :ChainableInitialization
  autoload :Error
  autoload :MassAssignment
  autoload :StrictMassAssignment
  autoload :UnknownAttributesError
  autoload :VERSION
end
