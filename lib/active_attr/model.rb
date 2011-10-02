require "active_support/concern"
require "active_model"

module ActiveAttr
  # Provides the minimum functionality to pass the ActiveModel lint tests
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::Model
  #   end
  #
  # @since 0.2.0
  module Model
    extend ActiveSupport::Concern
    extend ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion

    def persisted?
      false
    end
  end
end
