require "active_attr/attributes"
require "active_attr/mass_assignment"
require "active_model"
require "active_support/concern"

module ActiveAttr
  # Serialization is a shortcut for incorporating ActiveModel's
  # serialization functionality into your model with one include
  #
  # See the included modules to learn more.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::Serialization
  #   end
  #
  # @since 0.7.0
  module Serialization
    extend ActiveSupport::Concern
    include Attributes
    include MassAssignment
    include ActiveModel::Serializers::JSON
  end
end
