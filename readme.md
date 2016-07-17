# Ruby Serializer (v0.0.1)

A general purpose library for serializing models (e.g, an ActiveModel or a PORO)
into JSON using a declarative DSL. 

## Installation

```bash
  $ gem install ruby-serializer      # ... or add to your Gemfile as appropriate
```

## Usage

Assuming you have a model similar to...

```ruby
  class Shape
    attr :size, :color, :shape, ...
  end
```

You can declare a serializer as follows...

```ruby
  class ShapeSerializer < RubySerializer::Base
    expose :size
    expose :color
    expose :shape
  end
```

And serialize using...

```ruby
  shape = Shape.new(size: 'large', color: 'red', shape: 'square')    # load as appropriate
  json  = RubySerializer.as_json shape
  
  # { size: 'large', color: 'red', shape: 'square' }
```

### Serializer naming convention

By default, `ruby-serializer` will look for a serializer with the following naming convention 

```ruby
  "#{resource.class.name}Serializer"
```

But you can always specify the serializer class explicitly:

```ruby
  shape = Shape.new(...)
  json  = RubySerializer.as_json shape, with: MyCustomSerializer
```

## Beyond the basics

Ok, that was very basic, but with RubySerializer you can also:

  * expose attributes `:as` another name
  * expose attributes with a custom `:value`
  * expose attributes conditionally with `:only` and `:unless`
  * expose attributes within a nested `:namespace`
  * expose model `:errors` if `!model.valid?`
  * `:include` nested `:belongs_to` associated models
  * `:include` nested `:has_one` associated models
  * `:include` nested `:has_many` associated models

### Exposing attributes with another name

You can expose an attribute with a different name using `:as`

```ruby
  class UserSerializer < RubySerializer::Base
    expose :id
    expose :name,  as: :user_name
    expose :email, as: :user_email
  end
```

### Exposing attributes with custom values

You can expose an attribute with a different value using `:value`

```ruby
  class UserSerializer < RubySerializer::Base
    expose :id
    expose :static,   value: 'static'              # expose a static attribute
    expose :dynamic,  value: -> { resource.name }  # expose a dynamic attribute using a lambda
    expose :resource, value: :name                 # expose a dynamic attribute using a symbol (calls a method on the underlying resource automatically)
  end
```

### Exposing attributes conditionally

You can expose attributes conditionally using `:only` and `:unless`

```ruby
  class UserSerializer < RubySerializer::Base
    expose :id
    expose :name,   only:   -> { resource.name.present? }
    expose :email,  unless: -> { resource.email.blank?  }
    expose :errors, unless: :valid?
  end
```

### Exposing attributes within a namespace

You can nest serialized attributes using a `:namespace`:

```ruby
  class UserSerializer < RubySerializer::Base
    expose :id
    namespace :i18n do
      expose :locale
      expose :time_zone
    end
  end
```

### Exposing associations

>> _TODO_

### Exposing model validation errors

By default, if your underlying model responds to `:valid?` and returns `false` then the
serialized response will automatically include a serialized `:errors` attribute.

# Roadmap

  * ActionController integration
  * Extensibility with custom Field types
 
# License

See [LICENSE](https://github.com/jakesgordon/ruby-serializer/blob/master/LICENSE) file.

# Contact

If you have any ideas, feedback, requests or bug reports, you can reach me at
[jake@codeincomplete.com](mailto:jake@codeincomplete.com), or via
my website: [Code inComplete](http://codeincomplete.com).

