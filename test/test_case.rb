require_relative '../lib/ruby_serializer'

require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'

module RubySerializer
  class TestCase < Minitest::Test

    #----------------------------------------------------------------------------------------------

    def assert_set(expected, actual, message = nil)
      assert_equal Set.new(expected), Set.new(actual), message
    end

    #----------------------------------------------------------------------------------------------

  end
end
