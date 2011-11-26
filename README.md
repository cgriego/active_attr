# ActiveAttr #

[![Build History][2]][1]

ActiveAttr makes it easy to create plain old ruby models without reinventing
the wheel.

[API Documentation](http://rubydoc.info/gems/active_attr)

[1]: http://travis-ci.org/cgriego/active_attr
[2]: https://secure.travis-ci.org/cgriego/active_attr.png?branch=master

## Modules ##

### Model ###

The Model module is a shortcut for incorporating the most common model
functionality into your model with one include. All of the following modules
are included when you include Model.

    class Person
      include ActiveAttr::Model
    end

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

### Logger ###

Including the Logger module into your class will give you access to a
configurable logger in model classes and instances. Your preferred logger can
be configured on an instance, subclass, class, parent class, and globally by
setting ActiveAttr::Logger.logger. When using Rails, the Rails framework
logger will be configured by default.

    class Person
      include ActiveAttr::Logger
    end

    Person.logger = Logger.new(STDOUT)
    Person.logger? #=> true
    Person.logger.info "Logging an informational message"

    person = Person.new
    person.logger? #=> true
    person.logger = Logger.new(STDERR)
    person.logger.warn "Logging a warning message"

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

### MassAssignmentSecurity ###

Including the MassAssignmentSecurity module into your class extends the
MassAssignment methods to honor any declared mass assignment permission
blacklists or whitelists including support for mass assignment roles.

    class Person
      include ActiveAttr::MassAssignment
      attr_accessor :first_name, :last_name
      attr_protected :last_name
    end

    person = Person.new(:first_name => "Chris", :last_name => "Griego")
    person.first_name #=> "Chris"
    person.last_name #=> nil

### QueryAttributes ###

Including the QueryAttributes module into your class builds on Attributes by
providing instance methods for querying your attributes

    class Person
      include ActiveAttr::QueryAttributes

      attribute :first_name
      attribute :last_name
    end

    person = Person.new
    person.first_name = "Chris"
    person.first_name? #=> true
    person.last_name? #=> false

## Integrations ##

### Ruby on Rails ###

When using ActiveAttr inside a Rails application, ActiveAttr will configure
your models' default logger to use the Rails logger automatically. Just
include ActiveAttr in your Gemfile.

    gem "active_attr"

### RSpec ###

ActiveAttr comes with matchers and RSpec integration to assist you in testing
your models. The matchers also work with compatible frameworks like Shoulda.

    require "active_attr/rspec"

    describe Person do
      it { should have_attribute(:first_name) }
    end
