require_relative 'test_case'

module RubySerializer
  class AssociationTest < TestCase

    #----------------------------------------------------------------------------------------------

    AW = { id: 123, name: 'Addison-Wesley' }
    MS = { id: 99,  name: 'Microsoft Press' }
    PP = { isbn: '020161622X', name: 'Pragmatic Programmer', publisher_id: AW[:id] }
    DP = { isbn: '0201633612', name: 'Design Patterns',      publisher_id: AW[:id] }
    CC = { isbn: '0735619670', name: 'Code Complete',        publisher_id: MS[:id] }

    PORTLAND = { city: 'Portland', state: 'OR' }

    #----------------------------------------------------------------------------------------------

    class Publisher < Model
      attr :id, :name
      has_many :books
      has_one :address
    end

    class Book < Model
      attr :isbn, :name
      belongs_to :publisher
    end

    class Address < Model
      attr :city, :state
    end

    #----------------------------------------------------------------------------------------------

    class PublisherSerializer < RubySerializer::Base
      expose   :id
      expose   :name
      has_many :books
      has_one  :address
    end

    class BookSerializer < RubySerializer::Base
      expose     :isbn
      expose     :name
      belongs_to :publisher
    end

    class AddressSerializer < RubySerializer::Base
      expose :city
      expose :state
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

    def test_has_one
      publisher = Publisher.new(AW)
      publisher.address = Address.new(PORTLAND)
      json     = serialize publisher, include: :address
      expected = [ :id, :name, :address ]
      assert_set   expected,          json.keys
      assert_equal AW[:id],           json[:id]
      assert_equal AW[:name],         json[:name]
      assert_equal [ :city, :state ], json[:address].keys
      assert_equal PORTLAND[:city],   json[:address][:city]
      assert_equal PORTLAND[:state],  json[:address][:state]
    end

    def test_has_one_but_not_included
      publisher = Publisher.new(AW)
      publisher.address = Address.new(PORTLAND)
      json     = serialize publisher
      expected = [ :id, :name ]
      assert_set   expected,  json.keys
      assert_equal AW[:id],   json[:id]
      assert_equal AW[:name], json[:name]
      assert_equal nil,       json[:address]
    end

    #----------------------------------------------------------------------------------------------

    def test_has_many
      publisher = Publisher.new(AW)
      publisher.books << Book.new(PP)
      publisher.books << Book.new(DP)
      json     = serialize publisher, include: :books
      expected = [ :id, :name, :books ]
      assert_set   expected,                        json.keys
      assert_equal AW[:id],                         json[:id]
      assert_equal AW[:name],                       json[:name]
      assert_equal 2,                               json[:books].length
      assert_equal [ :isbn, :name, :publisher_id ], json[:books][0].keys
      assert_equal PP[:isbn],                       json[:books][0][:isbn]
      assert_equal PP[:name],                       json[:books][0][:name]
      assert_equal AW[:id],                         json[:books][0][:publisher_id]
      assert_equal [ :isbn, :name, :publisher_id ], json[:books][1].keys
      assert_equal DP[:isbn],                       json[:books][1][:isbn]
      assert_equal DP[:name],                       json[:books][1][:name]
      assert_equal AW[:id],                         json[:books][1][:publisher_id]
    end

    def test_has_many_but_not_included
      publisher = Publisher.new(AW)
      publisher.books << Book.new(PP)
      publisher.books << Book.new(DP)
      json     = serialize publisher
      expected = [ :id, :name ]
      assert_set   expected,         json.keys
      assert_equal AW[:id],          json[:id]
      assert_equal AW[:name],        json[:name]
      assert_equal nil,              json[:books]
    end

    #----------------------------------------------------------------------------------------------

  end
end
