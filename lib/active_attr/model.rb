require "active_model"
require "active_support/concern"

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
    include ActiveModel::Conversion
    include ActiveModel::Validations

    def persisted?
      false
    end
  end
end
