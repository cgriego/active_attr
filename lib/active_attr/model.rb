require "active_attr/attribute_defaults"
require "active_attr/basic_model"
require "active_attr/block_initialization"
require "active_attr/logger"
require "active_attr/mass_assignment_security"
require "active_attr/query_attributes"
require "active_attr/serialization"
require "active_attr/typecasted_attributes"
require "active_support/concern"

module ActiveAttr
  # Model is a shortcut for incorporating the most common model
  # functionality into your model with one include
  #
  # See the included modules to learn more.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::Model
  #   end
  #
  # @since 0.4.0
  module Model
    extend ActiveSupport::Concern
    include BasicModel
    include BlockInitialization
    include Logger
    include MassAssignmentSecurity
    include AttributeDefaults
    include QueryAttributes
    include TypecastedAttributes
    include Serialization
  end
end
