require_relative '../lib/ruby_serializer'

require 'minitest/autorun'
require 'minitest/pride'
# require 'awesome_print'
require 'byebug'

require_relative 'models/user'
require_relative 'models/company'
require_relative 'models/namespaced/book'
require_relative 'serializers/user_serializer'
require_relative 'serializers/company_serializer'
require_relative 'serializers/namespaced/book_serializer'

module RubySerializer
  class TestCase < Minitest::Test

    #----------------------------------------------------------------------------------------------
    # FIXTURES
    #----------------------------------------------------------------------------------------------

    JAKE          = { id: 42, name: 'Jake Gordon' }.freeze
    AMY           = { id: 99, name: 'Amy McGinnis' }.freeze
    WATSON        = { id: 123, name: 'Watson the Dog' }.freeze

    ACADEMYIO     = { id: 1000, name: 'Academy IO' }.freeze
    WASTELYTICS   = { id: 1001, name: 'Wastelytics' }.freeze
    TRIPGRID      = { id: 1002, name: 'TripGrid' }.freeze
    LIQUIDPLANNER = { id: 1003, name: 'LiquidPlanner' }.freeze

    LOTR          = { id: 2000, isbn: '1-2-3', name: 'Lord of the Rings' }.freeze
    HARRY_POTTER  = { id: 2001, isbn: '9-9-9', name: 'Harry Potter' }.freeze

    #----------------------------------------------------------------------------------------------

  end
end
