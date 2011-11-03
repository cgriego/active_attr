# ActiveAttr #

[![Build History][2]][1]

ActiveAttr makes it easy to create plain old ruby models without reinventing
the wheel.

[API Documentation](http://rubydoc.info/gems/active_attr)

[1]: http://travis-ci.org/cgriego/active_attr
[2]: https://secure.travis-ci.org/cgriego/active_attr.png?branch=master

## Modules ##

### Attributes ###

Including the Attributes module into your class gives you a DSL for defining
the attributes of your model.

    class Person
      include ActiveAttr::Attributes

      attribute :first_name
      attribute :last_name
    end

    person = Person.new
    person.first_name = "Chris"
    person.last_name = "Griego"
    person.attributes #=> {"first_name"=>"Chris", "last_name"=>"Griego"}

### BasicModel ###

Including the BasicModel module into your class gives you the bare minimum
required for your model to meet the ActiveModel API requirements.

    class Person
      include ActiveAttr::BasicModel
    end

    Person.model_name.plural #=> "people"
    person = Person.new
    person.valid? #=> true
    person.errors.full_messages #=> []

### BlockInitialization ###

Including the BlockInitialization module into your class will yield the model
instance to a block passed to when creating a new instance.

    class Person
      include ActiveAttr::BlockInitialization
      attr_accessor :first_name, :last_name
    end

    person = Person.new do |p|
      p.first_name = "Chris"
      p.last_name = "Griego"
    end

    person.first_name #=> "Chris"
    person.last_name #=> "Griego"

### MassAssignment ###

Including the MassAssignment module into your class gives you methods for bulk
initializing and updating the attributes of your model. Any unknown attributes
are silently ignored unless you substitute the StrictMassAssignment module
which will raise an exception if an attempt is made to assign an unknown
attribute.

    class Person
      include ActiveAttr::MassAssignment
      attr_accessor :first_name, :last_name
    end

    person = Person.new(:first_name => "Chris")
    person.attributes = { :last_name => "Griego" }
    person.first_name #=> "Chris"
    person.last_name #=> "Griego"

## RSpec Integration ##

ActiveAttr comes with matchers and RSpec integration to assist you in testing
your models.

    require "active_attr/rspec"

    describe Person do
      it { should have_attribute(:first_name) }
    end
