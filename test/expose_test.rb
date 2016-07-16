require_relative 'test_case'

module RubySerializer
  class ExposeTest < TestCase

    #----------------------------------------------------------------------------------------------

    class Serializer < RubySerializer::Base

      expose :id
      expose :name
      expose :url, as:   :website              # expose resource attribute AS serialized attribute
      expose :hq,  from: :headquarters         # expose serialized attribute FROM resource attribute

      namespace :financial do                  # group attributes in a namespace
        expose :ticker
        namespace :current do                  # group attributes in a nested namespace
          expose :price
          expose :cap
        end
      end

    end

    #----------------------------------------------------------------------------------------------

    def test_expose_options

      resource = OpenStruct.new(GOOGLE)
      json     = RubySerializer.serialize resource, with: Serializer
      expected = [ :id, :name, :website, :hq, :financial ]

      assert_set   expected,              json.keys,                           'expected only known keys to be serialized'
      assert_equal GOOGLE[:id],           json[:id],                           'expected :id to be exposed as-is'
      assert_equal GOOGLE[:name],         json[:name],                         'expected :name to be exposed as-is'
      assert_equal GOOGLE[:url],          json[:website],                      'expected :url (resource attribute) to be exposed AS :website (serialized attribute)'
      assert_equal GOOGLE[:headquarters], json[:hq],                           'expected :hq (serialized attribute) to be exposed FROM :headquarters (resource attribute)'
      assert_equal GOOGLE[:ticker],       json[:financial][:ticker],           'expected :ticker to be exposed within the :financial NAMESPACE'
      assert_equal GOOGLE[:price],        json[:financial][:current][:price],  'expected :price to be exposed within a nested :financial/current NAMESPACE'
      assert_equal GOOGLE[:cap],          json[:financial][:current][:cap],    'expected :market_cap to be exposed within a nested :financial/current NAMESPACE'

    end

    #----------------------------------------------------------------------------------------------

  end
end

