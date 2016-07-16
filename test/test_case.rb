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

    GOOGLE        = { id: 1003, name: 'Google',    url: 'www.google.com',    ticker: :googl, price: 734.63, market_cap: 504.28, ceo: 'Sundar Pichai' }.freeze
    MICROSOFT     = { id: 1009, name: 'Microsoft', url: 'www.microsoft.com', ticker: :msft,  price:  53.70, market_cap: 423.92, ceo: 'Satya Nadella' }.freeze
    ORACLE        = { id: 1011, name: 'Oracle',    url: 'www.oracle.com',    ticker: :orcl,  price:  41.77, market_cap: 173.08, ceo: 'Mark Hurd' }.freeze

    LOTR          = { id: 2000, isbn: '1-2-3', name: 'Lord of the Rings' }.freeze
    HARRY_POTTER  = { id: 2001, isbn: '9-9-9', name: 'Harry Potter' }.freeze

    #----------------------------------------------------------------------------------------------

    def assert_set(expected, actual, message)
      assert_equal Set.new(expected), Set.new(actual), message
    end

    #----------------------------------------------------------------------------------------------

  end
end
