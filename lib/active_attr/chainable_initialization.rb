module ActiveAttr
  # Allows classes and modules to safely invoke super in its initialize method
  #
  # Many ActiveAttr modules enhance the behavior of the \#initialize method,
  # and in doing so, these methods need to accept arguments. However, Ruby's
  # Object and BasicObject classes, in most versions of Ruby, do not allow any
  # arguments to be passed in. This module halts the propagation of
  # initialization arguments before invoking the Object class'
  # initialization.
  #
  # In order to still allow a subclass mixing in this module (directly or
  # through an ActiveSupport::Concern) to still pass its initialization
  # arguments to its superclass, the module has to install itself into the
  # ancestors of the base class, the class that inherits directly from Object
  # or BasicObject.
  #
  # @since 0.2.2
  module ChainableInitialization
    class << self
      # A collection of Ruby base objects
      #   [Object, BasicObject]
      #
      # @private
      BASE_OBJECTS = [Object, BasicObject]

      # Only append the features of this module to the class that inherits
      # directly from one of the BASE_OBJECTS
      #
      # @private
      def append_features(base)
        if base.respond_to? :superclass
          base = base.superclass while !BASE_OBJECTS.include? base.superclass
        end

        super
      end
    end

    # Continue to propagate any superclass calls, but stop passing arguments
    #
    # This prevents problems in versions of Ruby where Object#initialize does
    # not take arguments
    def initialize(*)
      super()
    end
  end
end
