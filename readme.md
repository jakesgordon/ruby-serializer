# Ruby Serializer (v1.0.0)

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

  user = User.new(id: 42, name: 'Jake', email: 'jake@codeincomplete.com')
  json = RubySerializer.as_json user

  # { id: 42, user_name: 'Jake', user_email: 'jake@codeincomplete.com' }
```

### Exposing attributes with custom values

You can expose an attribute with a different value using `:value`

```ruby
  class UserSerializer < RubySerializer::Base
    expose :id
    expose :static,  value: 'static'                      # expose a static attribute
    expose :dynamic, value: -> { resource.name.reverse }  # expose a dynamic attribute using a lambda
    expose :method,  value: :name                         # expose a dynamic attribute using a symbol (calls a method on the underlying resource automatically)
  end

  user = User.new(id: 42, name: 'Jake')
  json = RubySerializer.as_json user

  # { id: 42, static: 'static', dynamic: 'ekaJ', method: 'Jake' }
```

### Exposing attributes conditionally

You can expose attributes conditionally using `:only` and `:unless`

```ruby
  class UserSerializer < RubySerializer::Base
    expose :id
    expose :admin,  only: :admin?                             # expose this field only when resource.admin?
    expose :name,   only:   -> { resource.name.present? }     # expose this field only when resource.name.present?
    expose :email,  unless: -> { resource.email.blank?  }     # expose this field unless resource.email.blank?
  end

  user = User.new(id: 1)
  json = RubySerializer.as_json user

  # { id: 1 } 

  user = User.new(id: 2, name: 'Joe')
  json = RubySerializer.as_json user

  # { id: 2, name: 'Joe' }

  user = User.new(id: 3, name: 'Bob', admin: true)
  json = RubySerializer.as_json user

  # { id: 3, name: 'Bob', admin: true }

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

  user = User.new(id: 42, locale: 'en-us', time_zone: 'UTC')
  json = RubySerializer.as_json user

  # { id: 42, i18n: { locale: 'en-us', time_zone: 'UTC' } }
```

### Exposing associations

If your models have ActiveRecord like associations you can declare them in your serializers and
then use the optional `:include` mechanism to choose when to include them as nested resources
during serialization:

```ruby
  class Publisher
    attr :id, :name
    has_many :books
  end

  class Book
    attr :isbn, :name
    belongs_to :publisher
  end

  class PublisherSerializer
    expose :id
    expose :name
    has_many :books
  end

  class BookSerializer
    expose :isbn
    expose :name
    belongs_to :publisher
  end

  publisher = Publisher.new(id: 42, name: 'Addison Wesley')

  RubySerializer.as_json publisher                     # WITHOUT :include

  # { id: 42, name: 'Addison Wesley' }

  RubySerializer.as_json publisher, include: :books    # WITH :include

  # { id: 42, name: 'Addison Wesley', books: [
  #   { isbn: '020161622X', name: 'Pragmatic Programmer' },
  #   { isbn: '0201633612', name: 'Design Patterns '},
  #   ...
  # ] }
```

`ruby-serializer` supports `belongs_to`, `has_one`, and `has_many` associations.

You can include multiple associations using an array of includes:

```ruby
  RubySerializer.as_json publisher, include: [ :books, :address, :websites ]
```

You can also include nested associations:

```ruby
  RubySerializer.as_json publisher, include: { books: [ :authors ] }
```

### Exposing model validation errors

By default, if your underlying model responds to `:valid?` and returns `false` then the
serialized response will automatically include a serialized `:errors` attribute.

# License

See [LICENSE](https://github.com/jakesgordon/ruby-serializer/blob/master/LICENSE) file.

# Contact

If you have any ideas, feedback, requests or bug reports, you can reach me at
[jake@codeincomplete.com](mailto:jake@codeincomplete.com), or via
my website: [Code inComplete](http://codeincomplete.com).

