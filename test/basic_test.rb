require_relative 'test_case'

module RubySerializer
  class BasicTest < TestCase

    #----------------------------------------------------------------------------------------------

    def test_serialize_simple_poro
      user = User.new(JAKE)
      json = RubySerializer.serialize user
      assert_equal JAKE[:id],   json[:id]
      assert_equal JAKE[:name], json[:name]
    end

    def test_serialize_another_simple_poro
      company = Company.new(GOOGLE)
      json = RubySerializer.serialize company
      assert_equal GOOGLE[:id],   json[:id]
      assert_equal GOOGLE[:name], json[:name]
      assert_equal GOOGLE[:url],  json[:website], 'verify attribute can be exposed :as a different key'
    end

    def test_serialize_namespaced_poro
      book = Namespaced::Book.new(LOTR)
      json = RubySerializer.serialize book
      assert_equal LOTR[:id],   json[:id]
      assert_equal LOTR[:name], json[:name]
      assert_equal LOTR[:isbn], json[:isbn]
    end

    #----------------------------------------------------------------------------------------------

  end
end
