require "active_model"
require "active_support/concern"

module ActiveAttr
  # Provides the minimum functionality to pass the ActiveModel lint tests
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::BasicModel
  #   end
  #
  # @since 0.2.0
  module BasicModel
    extend ActiveSupport::Concern
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    # @return [true, false] True if this model should be conisdered persisted
    # @since 0.2.0
    def persisted?
      !!self.class.persistable.call(self)
    end

    module ClassMethods
      # Syntactic sugar for declaring state of persistence on this model
      #
      # @example
      #   class Report
      #     include ActiveAttr::BasicModel
      #     persisted_when { |report| report.processed? }
      #   end
      def persisted_when(persistable = nil, &block)
        @persistable = block || persistable
      end


      # This model should always be considered persisted
      #
      # @example
      #   class Report
      #     include ActiveAttr::BasicModel
      #     always_persisted
      #   end
      #
      #   Report.new.persisted? => true
      def always_persisted
        persisted_when { true }
      end

      # This model should never be considered persisted
      #
      # @example
      #   class Report
      #     include ActiveAttr::BasicModel
      #     never_persisted
      #   end
      #
      #   Report.new.persisted? => false
      def never_persisted
        persisted_when { false }
      end

      #:nodoc:
      def persistable
        @persistable ||= Proc.new { false }
      end
    end
  end
end
