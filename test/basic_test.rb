require_relative 'test_case'

module RubySerializer
  class BasicTest < TestCase

    #----------------------------------------------------------------------------------------------

    def test_detect_serializer
      user    = users(:jake)
      company = companies(:academyio)
      book    = books(:lotr)
      assert_equal UserSerializer,             RubySerializer.serializer(user)
      assert_equal CompanySerializer,          RubySerializer.serializer(company)
      assert_equal Namespaced::BookSerializer, RubySerializer.serializer(book)
    end

    #----------------------------------------------------------------------------------------------

    def test_serialize_simple_poro
      user = users(:jake)
      json = serialize user
      assert_equal JAKE[:id],   json[:id]
      assert_equal JAKE[:name], json[:name]
    end

    #----------------------------------------------------------------------------------------------

  end
end
