require_relative 'test_case'

module RubySerializer
  class ExposeTest < TestCase

    #----------------------------------------------------------------------------------------------

    ID     = 42
    NAME   = 'Name'
    EMAIL  = 'Email'
    SECRET = 'Secret'

    Resource = Struct.new(:id, :name, :email, :secret)

    #----------------------------------------------------------------------------------------------

    class BasicSerializer < RubySerializer::Base
      expose :id
      expose :name
      expose :email
    end

    class RenamingSerializer < RubySerializer::Base
      expose :id
      expose :name,       as:   :user_name
      expose :user_email, from: :email
    end

    class NamespaceSerializer < RubySerializer::Base
      expose :id
      namespace :user do
        expose :name
        expose :email
      end
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_attributes_unchanged
      resource = Resource.new(ID, NAME, EMAIL, SECRET)
      json = RubySerializer.serialize resource, with: BasicSerializer
      assert_equal [ :id, :name, :email ], json.keys
      assert_equal ID,    json[:id]
      assert_equal NAME,  json[:name]
      assert_equal EMAIL, json[:email]
    end

    def test_expose_renamed_attributes
      resource = Resource.new(ID, NAME, EMAIL, SECRET)
      json = RubySerializer.serialize resource, with: RenamingSerializer
      assert_equal [ :id, :user_name, :user_email ], json.keys
      assert_equal ID,    json[:id]
      assert_equal NAME,  json[:user_name]
      assert_equal EMAIL, json[:user_email]
    end

    def test_expose_namespaced_attributes
      resource = Resource.new(ID, NAME, EMAIL, SECRET)
      json = RubySerializer.serialize resource, with: NamespaceSerializer
      assert_equal [ :id, :user ],    json.keys
      assert_equal ID,                json[:id]
      assert_equal NAME,              json[:user][:name]
      assert_equal EMAIL,             json[:user][:email]
      assert_equal [ :name, :email ], json[:user].keys
    end

    #----------------------------------------------------------------------------------------------

  end
end

