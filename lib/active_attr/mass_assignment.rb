require "active_attr/chainable_initialization"
require "active_support/concern"

module ActiveAttr
  # MassAssignment allows you to bulk set and update attributes
  #
  # Including MassAssignment into your model gives it a set of mass assignment
  # methods, similar to those found in ActiveRecord.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::MassAssignment
  #   end
  #
  # @since 0.1.0
  module MassAssignment
    extend ActiveSupport::Concern
    include ChainableInitialization

    # Mass update a model's attributes
    #
    # @example Assigning a hash
    #   person.assign_attributes(:first_name => "Chris", :last_name => "Griego")
    #   person.first_name #=> "Chris"
    #   person.last_name #=> "Griego"
    #
    # @param [Hash{#to_s => Object}, #each] attributes Attributes used to
    #   populate the model
    #
    # @since 0.1.0
    def assign_attributes(new_attributes, options={})
      new_attributes.each do |name, value|
        writer = "#{name}="
        send writer, value if respond_to? writer
      end if new_attributes
    end

    # Mass update a model's attributes
    #
    # @example Assigning a hash
    #   person.attributes = { :first_name => "Chris", :last_name => "Griego" }
    #   person.first_name #=> "Chris"
    #   person.last_name #=> "Griego"
    #
    # @param (see #assign_attributes)
    #
    # @since 0.1.0
    def attributes=(new_attributes)
      assign_attributes new_attributes
    end

    # Initialize a model with a set of attributes
    #
    # @example Initializing with a hash
    #   person = Person.new(:first_name => "Chris", :last_name => "Griego")
    #   person.first_name #=> "Chris"
    #   person.last_name #=> "Griego"
    #
    # @param (see #assign_attributes)
    #
    # @since 0.1.0
    def initialize(attributes=nil, options={})
      assign_attributes attributes, options
      super
    end
  end
end
