require "active_attr/chainable_initialization"
require "active_support/concern"

module ActiveAttr
  # BlockInitialization allows you to build an instance in a block
  #
  # Including the BlockInitialization module into your class will yield the
  # model instance to a block passed to when creating a new instance.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::BlockInitialization
  #   end
  #
  # @since 0.3.0
  module BlockInitialization
    extend ActiveSupport::Concern
    include ChainableInitialization

    # Initialize a model and build via a block
    #
    # @example
    #   person = Person.new do |p|
    #     p.first_name = "Chris"
    #     p.last_name = "Griego"
    #   end
    #
    #   person.first_name #=> "Chris"
    #   person.last_name #=> "Griego"
    #
    # @since 0.3.0
    def initialize(*)
      super
      yield self if block_given?
    end
  end
end
