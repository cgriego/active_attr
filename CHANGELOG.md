# ActiveAttr 0.15.3 (April 12, 2021)

* #185 Fixed ReDoS vulnerability in BooleanTypecaster#call (ねず)

# ActiveAttr 0.15.2 (February 17, 2021)

* ActiveAttr now supports Ruby 3.0
* Allow unreleased versions of Rails 7.0

# ActiveAttr 0.15.1 (December 11, 2020) #

* ActiveAttr now supports Ruby 2.7
* ActiveAttr now supports Rails 6.1
* Drop support for Ruby versions below 2.1

# ActiveAttr 0.15.0 (June 12, 2019) #

* Add missing ActiveSupport require for Attributes
* Change numeric typecasters to cast nil and empty strings to nil

# ActiveAttr 0.14.0 (June 10, 2019) #

* Drop support for Ruby versions below 1.9.2
* #139 Changed Typecasting::BooleanTypecaster to cast nil and empty
  strings to false (Corin Langosch)
* Attributes#inspect is now filtered based on filtered_attributes,
  which defaults to `Rails.application.config.filter_parameters` in
  Rails apps.
* #143 Changed Attributes to allocate less objects (Chris Grigg)
* #153 Changed HaveAttributeMatcher#with_default_value_of to support
  Procs (Yoshiyuki Hirano)
* #145 Add ActiveModel::Validations::Callbacks to ActiveAttr::Model
  (Kazuki BABA)

# ActiveAttr 0.13.1 (April 25, 2019) #

* ActiveAttr now supports Rails 6.0

# ActiveAttr 0.13.0 (April 6, 2019) #

* ActiveAttr now supports Ruby 2.6

# ActiveAttr 0.12.0 (August 6, 2018) #

* #167 Changed Typecasting::BooleanTypecaster to cast strings starting
  with a zero character to cast to true (Artin Boghosian)
* Changed Typecasting::BooleanTypecaster to cast more numeric strings
  to true

# ActiveAttr 0.11.0 (May 29, 2018) #

* #166 Changed Typecasting::DateTimeTypecaster to not raise on invalid
  Strings (Omoto Kenji)

# ActiveAttr 0.10.3 (February 16, 2018) #

* ActiveAttr now supports Rails 5.2

# ActiveAttr 0.10.2 (July 21, 2017) #

* Add the license to the gemspec (Koichi ITO)

# ActiveAttr 0.10.1 (May 4, 2017) #

* Documentation and test updates for Ruby 2.4 deprecating Fixnum
* ActiveAttr now supports Rails 5.1

# ActiveAttr 0.10.0 (February 7, 2017) #

* ActiveAttr now supports Ruby 2.4.0

# ActiveAttr 0.9.0 (January 27, 2016) #

* ActiveAttr now supports Rails 5.0.0
* Following the lead of Rails 5, Serialization no longer includes XML
  serialization by default. Include the ActiveModel::Serializers::Xml
  module to get this functionality. With Rails 5. You'll need to
  install the activemodel-serializers-xml gem, which is not yet
  published on RubyGems.org

# ActiveAttr 0.8.5 (December 22, 2014) #

* ActiveAttr now supports Rails 4.2.0 (Jesse B. Hannah)

# ActiveAttr 0.8.4 (July 11, 2014) #

* ActiveAttr now supports RSpec 3.0.0 (Aaron Mc Adam)

# ActiveAttr 0.8.3 (April 8, 2014) #

* ActiveAttr now supports Rails 4.1.0

# ActiveAttr 0.8.2 (June 16, 2013) #

* #108 Fix grammar in HaveAttributeMatcher#description (Matt Hodan)
* #110 #116 Improve performance of typecasting (Roman Heinrich)

# ActiveAttr 0.8.1 (June 9, 2013) #

* #121 Fix compatibility with ActiveModel Serializers gem by dropping support
  for Rails 3.2 edge prior to RC1

# ActiveAttr 0.8.0 (May 2, 2013) #

* ActiveAttr now supports Rails 4.0.0
* ActiveAttr now supports Ruby 2.0.0
* HaveAttributeMatcher failure messages now use an expected/got format
* Removed MassAssignmentSecurity, sanitizer support has been merged into
  MassAssignment. Include the ActiveModel::MassAssignmentSecurity module or
  ActiveModel::ForbiddenAttributesProtection depending on your Rails version

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
