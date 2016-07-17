require_relative 'test_case'

module RubySerializer
  class AssociationTest < TestCase

    #----------------------------------------------------------------------------------------------

    ADDISON_WESLEY       = { id: 123, name: 'Addison-Wesley' }
    PRAGMATIC_PROGRAMMER = { isbn: '020161622X', name: 'Pragmatic Programmer' }

    #----------------------------------------------------------------------------------------------

    class Publisher < Model
      attr :id, :name
    end

    class Book < Model
      attr :isbn, :name
      belongs_to :publisher
    end

    class PublisherSerializer < RubySerializer::Base
      expose :id
      expose :name
    end

    class BookSerializer < RubySerializer::Base
      expose :isbn
      expose :name
      belongs_to :publisher
    end

    #----------------------------------------------------------------------------------------------

    def test_belongs_to
      publisher      = Publisher.new(ADDISON_WESLEY)
      book           = Book.new(PRAGMATIC_PROGRAMMER)
      book.publisher = publisher
      json = RubySerializer.as_json book, with: BookSerializer, include: :publisher
      expected = [ :isbn, :name, :publisher_id, :publisher ]
      assert_set expected, json.keys
      assert_equal PRAGMATIC_PROGRAMMER[:isbn], json[:isbn]
      assert_equal PRAGMATIC_PROGRAMMER[:name], json[:name]
      assert_equal ADDISON_WESLEY[:id],         json[:publisher_id]
      assert_equal [ :id, :name ],              json[:publisher].keys
      assert_equal ADDISON_WESLEY[:id],         json[:publisher][:id]
      assert_equal ADDISON_WESLEY[:name],       json[:publisher][:name]
    end

    def test_belongs_to_but_not_included
      publisher      = Publisher.new(ADDISON_WESLEY)
      book           = Book.new(PRAGMATIC_PROGRAMMER)
      book.publisher = publisher
      json = RubySerializer.as_json book, with: BookSerializer
      expected = [ :isbn, :name, :publisher_id ]
      assert_set expected, json.keys
      assert_equal PRAGMATIC_PROGRAMMER[:isbn], json[:isbn]
      assert_equal PRAGMATIC_PROGRAMMER[:name], json[:name]
      assert_equal ADDISON_WESLEY[:id],         json[:publisher_id]
      assert_equal nil,                         json[:publisher]
    end

    #----------------------------------------------------------------------------------------------

  end
end
