# Ruby Serializer (v0.0.1)

The ruby-serializer is a general purpose library for serializing models (e.g, an ActiveModel or a PORO)
into JSON using a declarative DSL. 

## Installation

```bash
    $ gem install ruby-serializer
```

## Usage

Assuming you have a model similar to...

```ruby
  class Shape
    attr :size, :color, :shape, # ...
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

```
  shape = Shape.new(size: 'large', color: 'red', shape: 'square')    # construct/load as appropriate for your models
  json  = RubySerializer.as_json shape
  
  # result:  { size: 'large', color: 'red', shape: 'square' }
```

Simple so far, but with RubySerializer you can also:

  * expose attributes `:as` another name
  * expose attributes with a custom `:value`
  * expose attributes conditionally with `:only` and `:unless`
  * expose attributes within a nested `:namespace`
  * expose model `:errors` if `!model.valid?`
  * `:include` nested `:belongs_to` associated models
  * `:include` nested `:has_one` associated models
  * `:include` nested `:has_many` associated models
  * serialize an array of models
  * add `ActionController` integration for easy API serialization

## Exposing attributes with another name

>> _TODO_


## Exposing attributes with custom values

>> _TODO_


## Exposing attributes conditionally

>> _TODO_


## Exposing attributes within a namespace

>> _TODO_


## Exposing model validation errors

>> _TODO_

## Exposing associations

>> _TODO_

## Serializing arrays

>> _TODO_

## ActionController integration

>> _TODO_

# TODO

  * :belongs_to
  * :has_one
  * :has_many
  * :includes
  * ActionController integration
  * documentation

# Future Features

  * Extensibility with custom Field types
 
License
=======

See [LICENSE](https://github.com/jakesgordon/ruby-serializer/blob/master/LICENSE) file.

Contact
=======

If you have any ideas, feedback, requests or bug reports, you can reach me at
[jake@codeincomplete.com](mailto:jake@codeincomplete.com), or via
my website: [Code inComplete](http://codeincomplete.com).

