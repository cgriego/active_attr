require "active_attr/mass_assignment"
require "active_support/concern"
require "active_model"

module ActiveAttr
  # MassAssignmentSecurity allows you to bulk set and update a blacklist or
  # whitelist of attributes
  #
  # Including MassAssignmentSecurity extends all {ActiveAttr::MassAssignment}
  # methods to honor any declared attribute permissions.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::MassAssignmentSecurity
  #   end
  #
  # @since 0.3.0
  module MassAssignmentSecurity
    extend ActiveSupport::Concern
    include MassAssignment
    include ActiveModel::MassAssignmentSecurity

    # Mass update a model's attributes, honoring attribute permissions
    #
    # @param (see MassAssignment#assign_attributes)
    # @param [Hash, #[]] options Options that affect mass assignment
    #
    # @option options [Symbol] :as (:default) Mass assignment role
    # @option options [true, false] :without_protection (false) Bypass mass
    #   assignment security if true
    #
    # @since 0.3.0
    def assign_attributes(new_attributes, options={})
      if new_attributes && !options[:without_protection]
        mass_assignment_role = options[:as] || :default
        new_attributes = sanitize_for_mass_assignment_with_or_without_role new_attributes, mass_assignment_role
      end

      super
    end

    private

    # Rails 3.0 has no roles support in mass assignment
    # @since 0.7.0
    def sanitize_for_mass_assignment_with_or_without_role(new_attributes, mass_assignment_role)
      if method(:sanitize_for_mass_assignment).arity.abs > 1
        sanitize_for_mass_assignment new_attributes, mass_assignment_role
      else
        sanitize_for_mass_assignment new_attributes
      end
    end
  end
end
