require_relative 'test_case'

module RubySerializer
  class AssociationTest < TestCase

    #----------------------------------------------------------------------------------------------

    AW = { id: 123, name: 'Addison-Wesley' }
    PP = { isbn: '020161622X', name: 'Pragmatic Programmer' }

    #----------------------------------------------------------------------------------------------

    class Publisher < Model
      attr :id, :name
    end

    class Book < Model
      attr :isbn, :name
      belongs_to :publisher
    end

    #----------------------------------------------------------------------------------------------

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
      publisher      = Publisher.new(AW)
      book           = Book.new(PP)
      book.publisher = publisher
      json           = serialize book, include: :publisher
      expected       = [ :isbn, :name, :publisher_id, :publisher ]
      assert_set   expected,        json.keys
      assert_equal PP[:isbn],       json[:isbn]
      assert_equal PP[:name],       json[:name]
      assert_equal AW[:id],         json[:publisher_id]
      assert_equal [ :id, :name ],  json[:publisher].keys
      assert_equal AW[:id],         json[:publisher][:id]
      assert_equal AW[:name],       json[:publisher][:name]
    end

    def test_belongs_to_but_not_included
      publisher      = Publisher.new(AW)
      book           = Book.new(PP)
      book.publisher = publisher
      json           = serialize book
      expected       = [ :isbn, :name, :publisher_id ]
      assert_set   expected,  json.keys
      assert_equal PP[:isbn], json[:isbn]
      assert_equal PP[:name], json[:name]
      assert_equal AW[:id],   json[:publisher_id]
      assert_equal nil,       json[:publisher]
    end

    #----------------------------------------------------------------------------------------------

  end
end
