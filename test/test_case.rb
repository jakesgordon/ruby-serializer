require_relative '../lib/ruby-serializer'

require 'minitest/autorun'
require 'minitest/pride'
require 'ostruct'
require 'byebug'

require_relative 'model'

module RubySerializer
  class TestCase < Minitest::Test

    #----------------------------------------------------------------------------------------------

    def serialize(resource, options = {})
      RubySerializer.as_json resource, options
    end

    #----------------------------------------------------------------------------------------------

    def assert_set(expected, actual, message = nil)
      assert_equal Set.new(expected), Set.new(actual), message
    end

    #----------------------------------------------------------------------------------------------

  end
end
