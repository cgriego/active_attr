# ActiveAttr 0.7.0 (December 15, 2012) #

* Added Serialization
* Changed Typecasting::DateTypecaster to not raise on invalid Strings
* #114 Fixed NoMethodError in TypecastedAttributes#attribute_before_type_cast

# ActiveAttr 0.6.0 (June 27, 2012) #

* Added AttributeDefinition#inspect
* Added Attributes.attribute!
* Added Attributes.dangerous_attribute?
* Added missing autoload for BlockInitialization
* Added Typecasting#typecaster_for
* Added Typecasting::UnknownTypecasterError
* Changed Typecasting#typecast_attribute to take a typecaster, not a type
* Removed Typecasting#typecast_value
* TypecastedAttributes now supports a :typecaster option on attribute
  definitions which can be any object that responds to #call

# ActiveAttr 0.5.1 (March 16, 2012) #

* ActiveAttr now supports Rails 3.0.2+ (Egor Baranov)

# ActiveAttr 0.5.0 (March 11, 2012) #

* ActiveAttr is now Ruby warning free
* Added AttributeDefaults
* Added AttributeDefinition#[]
* Added Attributes.attribute_names
* Added Matchers::HaveAttributeMatcher#of_type
* Added Matchers::HaveAttributeMatcher#with_default_value_of
* Added TypecastedAttributes
* Added Typecasting
* Added Typecasting::BigDecimalTypecaster
* Added Typecasting::Boolean
* Added Typecasting::BooleanTypecaster
* Added Typecasting::DateTimeTypecaster
* Added Typecasting::DateTypecaster
* Added Typecasting::FloatTypecaster
* Added Typecasting::IntegerTypecaster
* Added Typecasting::ObjectTypecaster
* Added Typecasting::StringTypecaster
* Changed Attributes.attributes return value from an Array to a Hash
* Changed HaveAttributeMatcher to return spec failures when the model is
  missing ActiveAttr modules
* Changed redefining an attribute to actually redefine the attribute
* Removed StrictMassAssignment, instead use MassAssignmentSecurity with
  ActiveModel v3.2 which allows assigning mass_assignment_sanitizer to
  :strict on the class

# ActiveAttr 0.4.1 (November 27, 2011) #

* Implemented ActiveModel serialization in Model

# ActiveAttr 0.4.0 (November 26, 2011) #

* Added Model
* Support for ActiveModel 3.2

# ActiveAttr 0.3.0 (November 26, 2011) #

* Added BlockInitialization
* Added DangerousAttributeError
* Added Logger
* Added MassAssignmentSecurity
* Added QueryAttributes
* Added UnknownAttributeError
* Attributes now honors getters/setters when calling #read_attribute,
  \#write_attribute, #[], and #[]=
* Attributes now raises DangerousAttributeError when defining an attribute
  whose methods would conflict with an existing method
* Attributes now raises UnknownAttributeError when getting/setting any
  undefined attributes

# ActiveAttr 0.2.2 (November 2, 2011) #

* Fixed all instances of modules' #initialize not invoking its superclass
* Fixed redefining an attribute appending a new AttributeDefinition
* Subclassing a model using Attributes will now copy the parent's attribute
  definitions to the subclass

# ActiveAttr 0.2.1 (October 19, 2011) #

* Added AttributeDefinition#<=>
* Added AttributeDefinition#to_sym
* Added Attributes#[]
* Added Attributes#[]=
* Attributes#attributes now returns the results of overridden getters
* Attributes.inspect and Attributes#inspect are now in alphabetical order
* Overridden attribute getters and setters can now call super

# ActiveAttr 0.2.0 (October 3, 2011) #

* ActiveAttr now autoloads nested classes and modules
* Added AttributeDefinition
* Added Attributes
* Added BasicModel
* Added Error
* Added Matchers::HaveAttributeMatcher
* Added StrictMassAssignment
* Added UnknownAttributesError
* Documented everything

# ActiveAttr 0.1.0 (September 30, 2011) #

* Added MassAssignment#assign_attributes
* Added MassAssignment#attributes=
* Added MassAssignment#initialize
