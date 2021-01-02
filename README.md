# ActiveAttr #

[![Build History][build badge]][build history]
[![Code Climate][codeclimate badge]][codeclimate]

ActiveAttr is a set of modules that makes it easy to create plain old Ruby
models with functionality found in ORMs, like ActiveRecord, without
reinventing the wheel. Think of ActiveAttr as the stuff ActiveModel left out.

ActiveAttr is distributed as a Ruby gem [on rubygems.org][rubygems].

[![ActiveAttr Railscast][railscast poster]][railscast]

* [Slides][speakerdeck]
* [RailsCast][railscast]
* [API Documentation][api]
* [Contributors][contributors]

[api]: http://rubydoc.info/gems/active_attr
[codeclimate badge]: https://codeclimate.com/github/cgriego/active_attr.svg
[codeclimate]: https://codeclimate.com/github/cgriego/active_attr
[contributors]: https://github.com/cgriego/active_attr/contributors
[railscast poster]: http://railscasts.com/static/episodes/stills/326-activeattr.png
[railscast]: http://railscasts.com/episodes/326-activeattr
[rubygems]: http://rubygems.org/gems/active_attr
[protected_attributes]: https://github.com/westonganger/protected_attributes_continued
[strong_parameters]: https://github.com/rails/strong_parameters
[speakerdeck]: https://speakerdeck.com/u/cgriego/p/models-models-every-where
[build badge]: https://github.com/cgriego/active_attr/workflows/Test/badge.svg?event=push
[build history]: https://github.com/cgriego/active_attr/actions?query=workflow%3ATest

## Modules ##

### Attributes ###

Including the Attributes module into your class gives you a DSL for defining
the attributes of your model.

```ruby
class Person
  include ActiveAttr::Attributes

  attribute :first_name
  attribute :last_name
end

person = Person.new
person.first_name = "Chris"
person.last_name = "Griego"
person.attributes #=> {"first_name"=>"Chris", "last_name"=>"Griego"}
```

#### AttributeDefaults ####

Including the AttributeDefaults module into your class builds on Attributes by
allowing defaults to be declared with attributes.

```ruby
class Person
  include ActiveAttr::AttributeDefaults

  attribute :first_name, :default => "John"
  attribute :last_name, :default => "Doe"
end

person = Person.new
person.first_name #=> "John"
person.last_name #=> "Doe"
```

#### QueryAttributes ####

Including the QueryAttributes module into your class builds on Attributes by
providing instance methods for querying your attributes.

```ruby
class Person
  include ActiveAttr::QueryAttributes

  attribute :first_name
  attribute :last_name
end

person = Person.new
person.first_name = "Chris"
person.first_name? #=> true
person.last_name? #=> false
```

#### TypecastedAttributes ####

Including the TypecastedAttributes module into your class builds on Attributes
by providing type conversion for your attributes.

```ruby
class Person
  include ActiveAttr::TypecastedAttributes
  attribute :age, :type => Integer
end

person = Person.new
person.age = "29"
person.age #=> 29
```

### BasicModel ###

Including the BasicModel module into your class gives you the bare minimum
required for your model to meet the ActiveModel API requirements.

```ruby
class Person
  include ActiveAttr::BasicModel
end

Person.model_name.plural #=> "people"
person = Person.new
person.valid? #=> true
person.errors.full_messages #=> []
```

### BlockInitialization ###

Including the BlockInitialization module into your class will yield the model
instance to a block passed to when creating a new instance.

```ruby
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
```

### Logger ###

Including the Logger module into your class will give you access to a
configurable logger in model classes and instances. Your preferred logger can
be configured on an instance, subclass, class, parent class, and globally by
setting ActiveAttr::Logger.logger. When using Rails, the Rails framework
logger will be configured by default.

```ruby
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
```

### MassAssignment ###

Including the MassAssignment module into your class gives you methods for bulk
initializing and updating the attributes of your model. Any unknown attributes
are silently ignored.

```ruby
class Person
  include ActiveAttr::MassAssignment
  attr_accessor :first_name, :last_name, :age
end

person = Person.new(:first_name => "Christopher", :last_name => "Griego")
person.attributes = { :first_name => "Chris", :age => 21 }
person.first_name #=> "Chris"
person.last_name #=> "Griego"
```

MassAssignment supports mass assignment security/sanitization if a sanitizer
is included in the model. If using Rails 4.0, include ActiveModel's forbidden
attributes protection module to get support for strong parameters.

```ruby
class Person
  include ActiveAttr::MassAssignment
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessor :first_name, :last_name
end

person = Person.new(ActionController::Parameters.new({
  :first_name => "Chris",
  :last_name => "Griego",
}).permit(:first_name))
person.first_name #=> "Chris"
person.last_name #=> nil
```

If using Rails 3.x or the [Protected Attributes gem][protected_attributes],
include ActiveModel's mass assignment security module to get support for
protected attributes, including support for mass assignment roles.

```ruby
class Person
  include ActiveAttr::MassAssignment
  include ActiveModel::MassAssignmentSecurity
  attr_accessor :first_name, :last_name
  attr_protected :last_name
end

person = Person.new(:first_name => "Chris", :last_name => "Griego")
person.first_name #=> "Chris"
person.last_name #=> nil
```

If using the [Strong Parameters gem][strong_parameters] with Rails 3.2,
include the forbidden attributes protection module after including
the mass assignment security module.

```ruby
class Person
  include ActiveAttr::MassAssignment
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::ForbiddenAttributesProtection
end
```

### Serialization ###

The Serialization module is a shortcut for incorporating ActiveModel's
serialization functionality into your model with one include.

```ruby
class Person
  include ActiveAttr::Serialization
end
```

### Model ###

The Model module is a shortcut for incorporating the most common model
functionality into your model with one include. All of the above modules
are included when you include Model.

```ruby
class Person
  include ActiveAttr::Model
end
```

## Integrations ##

### Ruby on Rails ###

When using ActiveAttr inside a Rails application, ActiveAttr will configure
your models' default logger to use the Rails logger automatically. Just
include ActiveAttr in your Gemfile.

```ruby
gem "active_attr"
```

### RSpec ###

ActiveAttr comes with matchers and RSpec integration to assist you in testing
your models. The matchers also work with compatible frameworks like Shoulda.

```ruby
require "active_attr/rspec"

describe Person do
  it do
    should have_attribute(:first_name).
      of_type(String).
      with_default_value_of("John")
  end
end
```
