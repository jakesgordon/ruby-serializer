require_relative '../lib/ruby_serializer'

require 'minitest/autorun'
require 'minitest/pride'
# require 'awesome_print'
require 'byebug'

require_relative 'models/company'
require_relative 'models/namespaced/book'
require_relative 'serializers/company_serializer'
require_relative 'serializers/namespaced/book_serializer'

module RubySerializer
  class TestCase < Minitest::Test

    #----------------------------------------------------------------------------------------------
    # FIXTURES
    #----------------------------------------------------------------------------------------------

    GOOGLE        = { id: 1003, name: 'Google',    url: 'www.google.com',    headquarters: 'Mountain View, CA', ticker: :googl, price: 734.63, cap: 504.28, ceo: 'Sundar Pichai' }.freeze
    MICROSOFT     = { id: 1009, name: 'Microsoft', url: 'www.microsoft.com', headquarters: 'Redmond, WA',       ticker: :msft,  price:  53.70, cap: 423.92, ceo: 'Satya Nadella' }.freeze
    ORACLE        = { id: 1011, name: 'Oracle',    url: 'www.oracle.com',    headquarters: 'Redwood City, CA',  ticker: :orcl,  price:  41.77, cap: 173.08, ceo: 'Mark Hurd' }.freeze

    LOTR          = { id: 2000, isbn: '1-2-3', name: 'Lord of the Rings' }.freeze
    HARRY_POTTER  = { id: 2001, isbn: '9-9-9', name: 'Harry Potter' }.freeze

    #----------------------------------------------------------------------------------------------

    def assert_set(expected, actual, message)
      assert_equal Set.new(expected), Set.new(actual), message
    end

    #----------------------------------------------------------------------------------------------

  end
end
