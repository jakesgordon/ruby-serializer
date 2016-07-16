require_relative 'test_case'

module RubySerializer
  class ExposeTest < TestCase

    #----------------------------------------------------------------------------------------------

    class ExposeTestSerializer < RubySerializer::Base

      expose :id
      expose :name
      expose :url, as: :website

      namespace :financial do
        expose :ticker
        namespace :current do
          expose :price
          expose :market_cap, as: :cap
        end
      end

    end

    #----------------------------------------------------------------------------------------------

    def test_expose_options

      resource = OpenStruct.new(GOOGLE)
      json     = RubySerializer.serialize resource, with: ExposeTestSerializer
      expected = [ :id, :name, :website, :financial ]

      assert_set   expected,            json.keys,                           'expected only known keys to be serialized'
      assert_equal GOOGLE[:id],         json[:id],                           'expected :id to be exposed as-is'
      assert_equal GOOGLE[:name],       json[:name],                         'expected :name to be exposed as-is'
      assert_equal GOOGLE[:url],        json[:website],                      'expected :url to be exposed AS :website'
      assert_equal GOOGLE[:ticker],     json[:financial][:ticker],           'expected :ticker to be exposed within the :financial NAMESPACE'
      assert_equal GOOGLE[:price],      json[:financial][:current][:price],  'expected :price to be exposed within a nested :financial/current NAMESPACE'
      assert_equal GOOGLE[:market_cap], json[:financial][:current][:cap],    'expected :market_cap to be exposed within a nested :financial/current NAMESPACE AS :cap'

    end

    #----------------------------------------------------------------------------------------------

  end
end

