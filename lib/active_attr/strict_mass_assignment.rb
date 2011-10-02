require "active_attr/mass_assignment"
require "active_attr/unknown_attributes_error"
require "active_support/concern"

module ActiveAttr
  # StrictMassAssignment allows mass assignment of attributes, but raises an
  # exception when assigning unknown attributes
  #
  # Attempting to assign any unknown or private attribute through any of the
  # mass assignment methods ({#assign_attributes}, {#attributes=}, and
  # {#initialize}) will raise an {ActiveAttr::UnknownAttributesError}
  # exception.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::StrictMassAssignment
  #   end
  #
  # @since 0.2.0
  module StrictMassAssignment
    extend ActiveSupport::Concern
    include MassAssignment

    # Mass update a model's attributes, but raise an error if an attempt is
    # made to assign an unknown attribute
    #
    # @param (see MassAssignment#assign_attributes)
    #
    # @raise [ActiveAttr::UnknownAttributesError]
    #
    # @since 0.2.0
    def assign_attributes(new_attributes, options={})
      unknown_attribute_names = (new_attributes || {}).reject do |name, value|
        respond_to? "#{name}="
      end.map { |name, value| name.to_s }.sort

      if unknown_attribute_names.any?
        raise UnknownAttributesError, "unknown attribute(s): #{unknown_attribute_names.join(", ")}"
      else
        super
      end
    end
  end
end
