require_relative 'test_case'

module RubySerializer
  class BasicTest < TestCase

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
