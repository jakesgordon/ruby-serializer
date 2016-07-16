require_relative 'test_case'

module RubySerializer
  class ExposeTest < TestCase

    #----------------------------------------------------------------------------------------------

    class ExposeTestSerializer < RubySerializer::Base
      expose :id
      expose :name
      expose :url, as: :website
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_options

      resource = OpenStruct.new(GOOGLE)
      json     = RubySerializer.serialize resource, with: ExposeTestSerializer
      expected = [ :id, :name, :website ]

      assert_set   expected,      json.keys,      'expected only known keys to be serialized'
      assert_equal GOOGLE[:id],   json[:id],      'expected :id to be exposed as-is'
      assert_equal GOOGLE[:name], json[:name],    'expected :name to be exposed as-is'
      assert_equal GOOGLE[:url],  json[:website], 'expected :url to be exposed as :website'

    end

    #----------------------------------------------------------------------------------------------

  end
end

