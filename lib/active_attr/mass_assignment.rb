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
      if new_attributes
        prepare_attributes(new_attributes).each do |name, value|
          writer = "#{name}="
          send writer, value if respond_to? writer
        end
      end
    end

    def prepare_attributes(attrs)
      multi_attr_pairs = []

      attrs.inject({}) do |res, (name, value)|
        if name.to_s.include?("(")
          multi_attr_pairs << [name, value]
        else
          res[name] = value
        end

        res
      end.merge(prepare_multi_attrs(multi_attr_pairs))
    end

    def prepare_multi_attrs(pairs)
      attributes = {}

      pairs.each do |pair|
        multiparameter_name, value = pair
        attribute_name = multiparameter_name.split("(").first
        attributes[attribute_name] = {} unless attributes.include?(attribute_name)

        parameter_value = value.empty? ? nil : type_cast_attribute_value(multiparameter_name, value)
        attributes[attribute_name][find_parameter_position(multiparameter_name)] ||= parameter_value
      end

      attributes.inject({}) { |res, (k, v)| res[k] = ActiveAttr::MultiAttr.new(v); res }
    end

    def type_cast_attribute_value(multiparameter_name, value)
      multiparameter_name =~ /\([0-9]*([if])\)/ ? value.send("to_" + $1) : value
    end

    def find_parameter_position(multiparameter_name)
      multiparameter_name.scan(/\(([0-9]*).*\)/).first.first.to_i
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
