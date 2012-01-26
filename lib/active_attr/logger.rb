require "active_support/concern"
require "active_support/core_ext/class/attribute"

module ActiveAttr
  # Provides access to a configurable logger in model classes and instances
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::Logger
  #   end
  #
  # @since 0.3.0
  module Logger
    extend ActiveSupport::Concern

    # The global default logger
    #
    # @return [nil, Object] logger Configured global default logger
    #
    # @since 0.3.0
    def self.logger
      @logger ||= nil
    end

    # Configure the global default logger
    #
    # @param [Logger, #debug] logger The new global default logger
    #
    # @since 0.3.0
    def self.logger=(new_logger)
      @logger = new_logger
    end

    # Determine if a global default logger is configured
    #
    # @since 0.3.0
    def self.logger?
      !!logger
    end

    included do
      class_attribute :logger
      self.logger = Logger.logger
    end
  end
end
