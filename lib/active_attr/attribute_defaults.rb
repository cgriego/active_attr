require "active_attr/attributes"
require "active_attr/chainable_initialization"
require "active_support/concern"
require "active_support/core_ext/object/duplicable"

module ActiveAttr
  # AttributeDefaults allows defaults to be declared for your attributes
  #
  # Defaults are declared by passing the :default option to the attribute
  # class method. If you need the default to be dynamic, pass a lambda, Proc,
  # or any object that responds to #call as the value to the :default option
  # and the result will calculated on initialization. These dynamic defaults
  # can depend on the values of other attributes when those attributes are
  # assigned using MassAssignment or BlockInitialization.
  #
  # @example Usage
  #   class Person
  #     include ActiveAttr::AttributeDefaults
  #
  #     attribute :first_name, :default => "John"
  #     attribute :last_name, :default => "Doe"
  #   end
  #
  #   person = Person.new
  #   person.first_name #=> "John"
  #   person.last_name #=> "Doe"
  #
  # @example Dynamic Default
  #   class Event
  #     include ActiveAttr::MassAssignment
  #     include ActiveAttr::AttributeDefaults
  #
  #     attribute :start_date
  #     attribute :end_date, :default => lambda { start_date }
  #   end
  #
  #   event = Event.new(:start_date => Date.parse("2012-01-01"))
  #   event.end_date.to_s #=> "2012-01-01"
  #
  # @since 0.5.0
  module AttributeDefaults
    extend ActiveSupport::Concern
    include ActiveAttr::ChainableInitialization
    include Attributes

    # Applies the attribute defaults
    #
    # Applies all the default values to any attributes not yet set, avoiding
    # any attribute setter logic, such as dirty tracking.
    #
    # @example Usage
    #   class Person
    #     include ActiveAttr::AttributeDefaults
    #
    #     attribute :first_name, :default => "John"
    #
    #     def reset!
    #       @attributes = {}
    #       apply_defaults
    #     end
    #   end
    #
    #   person = Person.new(:first_name => "Chris")
    #   person.reset!
    #   person.first_name #=> "John"
    #
    # @param [Hash{String => Object}, #each] defaults The defaults to apply
    #
    # @since 0.5.0
    def apply_defaults(defaults=attribute_defaults)
      @attributes ||= {}
      defaults.each do |name, value|
        # instance variable is used here to avoid any dirty tracking in attribute setter methods
        @attributes[name] = value unless @attributes.has_key? name
      end
    end

    # Calculates the attribute defaults from the attribute definitions
    #
    # @example Usage
    #   class Person
    #     include ActiveAttr::AttributeDefaults
    #
    #     attribute :first_name, :default => "John"
    #   end
    #
    #   Person.new.attribute_defaults #=> {"first_name"=>"John"}
    #
    # @return [Hash{String => Object}] the attribute defaults
    #
    # @since 0.5.0
    def attribute_defaults
      attributes_map { |name| _attribute_default name }
    end

    # Applies attribute default values
    #
    # @since 0.5.0
    def initialize(*)
      super
      apply_defaults
    end

    private

    # Calculates an attribute default
    #
    # @private
    # @since 0.5.0
    def _attribute_default(attribute_name)
      default = self.class.attributes[attribute_name][:default]

      case
      when default.respond_to?(:call) then instance_exec(&default)
      when default.duplicable? then default.dup
      else default
      end
    end
  end
end
