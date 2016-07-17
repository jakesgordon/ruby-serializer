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

    Shape = Struct.new(:color, :shape)
    Car   = Struct.new(:make, :model)

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

      json = RubySerializer.serialize Shape.new(:red, :square)
      assert_set   [ :color, :shape ], json.keys
      assert_equal :red,               json[:color]
      assert_equal :square,            json[:shape]

      json = RubySerializer.serialize Car.new(:honda, :civic)
      assert_set   [ :make, :model ], json.keys
      assert_equal :honda,            json[:make]
      assert_equal :civic,            json[:model]

    end

    #----------------------------------------------------------------------------------------------

    def test_array_serialization
      resources = [
        Shape.new(:red,  :square),
        Shape.new(:blue, :circle),
        Car.new(:honda, :civic),
        Car.new(:jeep, :wrangler)
      ]
      json = RubySerializer.serialize resources
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
      json = RubySerializer.serialize Car.new(:honda, :civic), root: :car
      assert_set [ :car ], json.keys
      assert_equal :honda, json[:car][:make]
      assert_equal :civic, json[:car][:model]
    end

    #----------------------------------------------------------------------------------------------

  end
end
