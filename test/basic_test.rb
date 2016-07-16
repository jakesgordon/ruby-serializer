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

    Shape = Struct.new(:size, :color)
    Car   = Struct.new(:make, :model)

    class ShapeSerializer < RubySerializer::Base
      expose :size
      expose :color
    end

    class CarSerializer < RubySerializer::Base
      expose :make
      expose :model
    end

    #----------------------------------------------------------------------------------------------

    def test_basic_serialization

      json = RubySerializer.serialize Shape.new(:large, :red)
      assert_set   [ :size, :color ], json.keys
      assert_equal :large,            json[:size]
      assert_equal :red,              json[:color]

      json = RubySerializer.serialize Car.new(:honda, :civic)
      assert_set   [ :make, :model ], json.keys
      assert_equal :honda,            json[:make]
      assert_equal :civic,            json[:model]

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
