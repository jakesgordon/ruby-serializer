require_relative 'test_case'

module RubySerializer
  class ExposeTest < TestCase

    #----------------------------------------------------------------------------------------------

    ID     = 42
    NAME   = 'Name'
    EMAIL  = 'Email'
    SECRET = 'Secret'

    Resource = OpenStruct

    #==============================================================================================
    # Sample Serializers
    #==============================================================================================

    class BasicSerializer < RubySerializer::Base
      expose :id
      expose :name
      expose :email
    end

    #----------------------------------------------------------------------------------------------

    class RenamingSerializer < RubySerializer::Base
      expose :id
      expose :name,       as:   :user_name
      expose :user_email, from: :email
    end

    #----------------------------------------------------------------------------------------------

    class NamespaceSerializer < RubySerializer::Base
      expose :id
      namespace :user do
        expose :name
        expose :email
      end
    end

    #----------------------------------------------------------------------------------------------

    class CustomValueSerializer < RubySerializer::Base
      expose :id
      expose :static,  value: 'static value'
      expose :method,  value: :method_value
      expose :dynamic, value: -> { "dynamic value (#{resource.name})" }
      expose :empty,   value: nil
    end

    #----------------------------------------------------------------------------------------------

    class ConditionalSerializer < RubySerializer::Base
      expose :id
      expose :only_true,      value: 'only true',      only: true
      expose :only_false,     value: 'only false',     only: false
      expose :only_method,    value: 'only method',    only: :show
      expose :only_dynamic,   value: 'only dynamic',   only: -> { resource.show }
      expose :unless_true,    value: 'unless true',    unless: true
      expose :unless_false,   value: 'unless false',   unless: false
      expose :unless_method,  value: 'unless method',  unless: :show
      expose :unless_dynamic, value: 'unless dynamic', unless: -> { resource.show }
    end

    #----------------------------------------------------------------------------------------------

    class CustomResourceNameSerializer < RubySerializer::Base
      serializes :user
      expose :id
      expose :value,       value: -> { "value is #{user.value}" }
      expose :show_only,   value: 'show only',   only: ->   { user.show }
      expose :show_unless, value: 'show unless', unless: -> { user.show }
    end

    #==============================================================================================
    # TESTS
    #==============================================================================================

    def test_expose_attributes_unchanged
      resource = Resource.new(id: ID, name: NAME, email: EMAIL, secret: SECRET)
      json     = RubySerializer.serialize resource, with: BasicSerializer
      expected = [ :id, :name, :email ]
      assert_set   expected, json.keys
      assert_equal ID,       json[:id]
      assert_equal NAME,     json[:name]
      assert_equal EMAIL,    json[:email]
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_renamed_attributes
      resource = Resource.new(id: ID, name: NAME, email: EMAIL, secret: SECRET)
      json     = RubySerializer.serialize resource, with: RenamingSerializer
      expected = [ :id, :user_name, :user_email ]
      assert_set   expected, json.keys
      assert_equal ID,       json[:id]
      assert_equal NAME,     json[:user_name]
      assert_equal EMAIL,    json[:user_email]
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_namespaced_attributes
      resource = Resource.new(id: ID, name: NAME, email: EMAIL, secret: SECRET)
      json     = RubySerializer.serialize resource, with: NamespaceSerializer
      expected = [ :id, :user ]
      assert_set   expected,          json.keys
      assert_equal ID,                json[:id]
      assert_equal NAME,              json[:user][:name]
      assert_equal EMAIL,             json[:user][:email]
      assert_equal [ :name, :email ], json[:user].keys
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_attributes_with_custom_values
      resource = Resource.new(id: ID, name: NAME, method_value: 'method value')
      json     = RubySerializer.serialize resource, with: CustomValueSerializer
      expected = [ :id, :static, :dynamic, :method, :empty ]
      assert_set   expected,               json.keys
      assert_equal ID,                     json[:id]
      assert_equal 'static value',         json[:static]
      assert_equal 'dynamic value (Name)', json[:dynamic]
      assert_equal 'method value',         json[:method]
      assert_equal nil,                    json[:empty]
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_attributes_conditionally
      show        = RubySerializer.serialize Resource.new(id: ID, show: true),  with: ConditionalSerializer
      noshow      = RubySerializer.serialize Resource.new(id: ID, show: false), with: ConditionalSerializer
      unspecified = RubySerializer.serialize Resource.new(id: ID),              with: ConditionalSerializer
      assert_set [ :id, :only_true, :unless_false, :only_method,   :only_dynamic   ], show.keys
      assert_set [ :id, :only_true, :unless_false, :unless_method, :unless_dynamic ], noshow.keys
      assert_set [ :id, :only_true, :unless_false, :unless_method, :unless_dynamic ], unspecified.keys
    end

    #----------------------------------------------------------------------------------------------

    def test_expose_attributes_using_custom_resource_name
      resource = Resource.new(id: ID, value: SECRET)
      json     = RubySerializer.serialize resource, with: CustomResourceNameSerializer
      expected = [ :id, :value, :show_unless ]
      assert_set   expected,             json.keys
      assert_equal ID,                   json[:id]
      assert_equal "value is #{SECRET}", json[:value]
      assert_equal "show unless",        json[:show_unless]
    end

    #----------------------------------------------------------------------------------------------

  end
end
