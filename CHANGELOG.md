# ActiveAttr 0.2.2 (unreleased) #

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
