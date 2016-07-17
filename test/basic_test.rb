require_relative 'test_case'

module RubySerializer
  class BasicTest < TestCase

    #----------------------------------------------------------------------------------------------

    def test_gem_information
      assert_equal '0.0.1',                         VERSION
      assert_equal 'Serialize POROs to JSON',       SUMMARY
      assert_match 'A general purpose library for', DESCRIPTION
    end

    #----------------------------------------------------------------------------------------------

    class Shape < Model
      attr :color, :shape
    end

    class Car < Model
      attr :make, :model
    end

    class ShapeSerializer < RubySerializer::Base
      expose :color
      expose :shape
    end

    class CarSerializer < RubySerializer::Base
      expose :make
      expose :model
    end

    #----------------------------------------------------------------------------------------------

    def test_basic_serialization

      json = RubySerializer.as_json Shape.new(color: :red, shape: :square)
      assert_set   [ :color, :shape ], json.keys
      assert_equal :red,               json[:color]
      assert_equal :square,            json[:shape]

      json = RubySerializer.as_json Car.new(make: :honda, model: :civic)
      assert_set   [ :make, :model ], json.keys
      assert_equal :honda,            json[:make]
      assert_equal :civic,            json[:model]

    end

    #----------------------------------------------------------------------------------------------

    def test_array_serialization
      resources = [
        Shape.new(color: :red,  shape: :square),
        Shape.new(color: :blue, shape: :circle),
        Car.new(make: :honda, model: :civic),
        Car.new(make: :jeep,  model: :wrangler)
      ]
      json = RubySerializer.as_json resources
      assert_equal resources.length, json.length
      assert_set   [ :color, :shape ], json[0].keys
      assert_equal :red,               json[0][:color]
      assert_equal :square,            json[0][:shape]
      assert_equal [ :color, :shape ], json[1].keys
      assert_equal :blue,              json[1][:color]
      assert_equal :circle,            json[1][:shape]
      assert_equal [ :make, :model ],  json[2].keys
      assert_equal :honda,             json[2][:make]
      assert_equal :civic,             json[2][:model]
      assert_equal [ :make, :model ],  json[3].keys
      assert_equal :jeep,              json[3][:make]
      assert_equal :wrangler,          json[3][:model]
    end

    #----------------------------------------------------------------------------------------------

    def test_serialize_with_root
      json = RubySerializer.as_json Car.new(make: :honda, model: :civic), root: :car
      assert_set [ :car ], json.keys
      assert_equal :honda, json[:car][:make]
      assert_equal :civic, json[:car][:model]
    end

    #----------------------------------------------------------------------------------------------

    def test_serialize_with_errors
      resource = Shape.new(color: :red, shape: :sausages, valid: false, errors: { shape: 'is invalid' })
      json     = RubySerializer.as_json resource, with: ShapeSerializer
      expected = [ :color, :shape, :errors ]
      assert_set expected,       json.keys
      assert_equal :red,         json[:color]
      assert_equal :sausages,    json[:shape]
      assert_set   [ :shape ],   json[:errors].keys
      assert_equal 'is invalid', json[:errors][:shape]
    end

    #----------------------------------------------------------------------------------------------

  end
end
