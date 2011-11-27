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
