require_relative 'test_case'

module RubySerializer
  class ExposeTest < TestCase

    #----------------------------------------------------------------------------------------------

    ID     = 42
    NAME   = 'Name'
    EMAIL  = 'Email'
    SECRET = 'Secret'

    Resource = OpenStruct

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

    class CustomValueSerializer < RubySerializer::Base
      expose :id
      expose :static,  value: 'static value'
      expose :method,  value: :method_value
      expose :dynamic, value: -> { 'dynamic value' }
      expose :empty,   value: nil
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_attributes_unchanged
      resource = Resource.new(id: ID, name: NAME, email: EMAIL, secret: SECRET)
      json = RubySerializer.serialize resource, with: BasicSerializer
      assert_set   [ :id, :name, :email ], json.keys
      assert_equal ID,    json[:id]
      assert_equal NAME,  json[:name]
      assert_equal EMAIL, json[:email]
    end

    def test_expose_renamed_attributes
      resource = Resource.new(id: ID, name: NAME, email: EMAIL, secret: SECRET)
      json = RubySerializer.serialize resource, with: RenamingSerializer
      assert_set   [ :id, :user_name, :user_email ], json.keys
      assert_equal ID,    json[:id]
      assert_equal NAME,  json[:user_name]
      assert_equal EMAIL, json[:user_email]
    end

    def test_expose_namespaced_attributes
      resource = Resource.new(id: ID, name: NAME, email: EMAIL, secret: SECRET)
      json = RubySerializer.serialize resource, with: NamespaceSerializer
      assert_set   [ :id, :user ],    json.keys
      assert_equal ID,                json[:id]
      assert_equal NAME,              json[:user][:name]
      assert_equal EMAIL,             json[:user][:email]
      assert_equal [ :name, :email ], json[:user].keys
    end

    def test_expose_attributes_with_custom_values
      resource = Resource.new(id: ID, method_value: 'method value')
      json = RubySerializer.serialize resource, with: CustomValueSerializer
      assert_set [ :id, :static, :dynamic, :method, :empty ], json.keys
      assert_equal ID, json[:id]
      assert_equal 'static value',  json[:static]
      assert_equal 'dynamic value', json[:dynamic]
      assert_equal 'method value',  json[:method]
      assert_equal nil,             json[:empty]
    end

    #----------------------------------------------------------------------------------------------

  end
end

