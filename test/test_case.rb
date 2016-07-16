require_relative '../lib/ruby_serializer'

require 'minitest/autorun'
require 'minitest/pride'
# require 'awesome_print'

require_relative 'models/user'
require_relative 'models/company'
require_relative 'serializers/user_serializer'
require_relative 'serializers/company_serializer'

module RubySerializer
  class TestCase < Minitest::Test

    #----------------------------------------------------------------------------------------------

    def serialize(entity, options = {})
      { id: 42, name: 'Jake Gordon' }
    end

    #----------------------------------------------------------------------------------------------
    # FIXTURES
    #----------------------------------------------------------------------------------------------

    JAKE   = { id: 42, name: 'Jake Gordon' }.freeze
    AMY    = { id: 99, name: 'Amy McGinnis' }.freeze
    WATSON = { id: 123, name: 'Watson the Dog' }.freeze

    def users(key)
      case key
      when :jake   then User.new(JAKE)
      when :amy    then User.new(AMY)
      when :watson then User.new(WATSON)
      else
        raise ArgumentError, 'unknown fixture'
      end
    end

    #----------------------------------------------------------------------------------------------

  end
end
