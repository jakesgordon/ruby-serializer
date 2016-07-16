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

      shape = RubySerializer.serialize Shape.new(:large, :red)
      assert_set   [ :size, :color ], shape.keys
      assert_equal :large,            shape[:size]
      assert_equal :red,              shape[:color]

      car = RubySerializer.serialize Car.new(:honda, :civic)
      assert_set   [ :make, :model ], car.keys
      assert_equal :honda,            car[:make]
      assert_equal :civic,            car[:model]

    end

    #----------------------------------------------------------------------------------------------

  end
end
