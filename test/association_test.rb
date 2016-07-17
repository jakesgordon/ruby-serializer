require_relative 'test_case'

module RubySerializer
  class AssociationTest < TestCase

    #----------------------------------------------------------------------------------------------

    PORTLAND = { id: :portland, city: 'Portland',      state: 'OR' }
    SEATTLE  = { id: :seattle,  city: 'Seattle',       state: 'WA' }
    BOSTON   = { id: :boston,   city: 'Boston',        state: 'MA' }
    NYC      = { id: :nyc,      city: 'New York',      state: 'NY' }
    SF       = { id: :sf,       city: 'San Francisco', state: 'CA' }
    LA       = { id: :la,       city: 'Los Angeles',   state: 'LA' }
    CHICAGO  = { id: :chicago,  city: 'Chicago',       state: 'IL' }
    DALLAS   = { id: :dallas,   city: 'Dallas',        state: 'TX' }
    REDMOND  = { id: :redmond,  city: 'Redmond',       state: 'WA' }

    MCCONNEL  = { id: :mcconnel,  name: 'Steve McConnel', address: SEATTLE  }
    HUNT      = { id: :hunt,      name: 'Andrew Hunt',    address: PORTLAND }
    THOMAS    = { id: :thomas,    name: 'David Thomas',   address: BOSTON   }
    GAMMA     = { id: :gamma,     name: 'Erich Gamma',    address: NYC      }
    HELM      = { id: :helm,      name: 'Richard Helm',   address: SF       }
    JOHNSON   = { id: :johnson,   name: 'Ralph Johnson',  address: CHICAGO  }
    VLISSIDES = { id: :vlissides, name: 'John Vlissides', address: DALLAS   }

    PP = { id: :pp, isbn: '020161622X', name: 'Pragmatic Programmer', publisher_id: :aw, authors: [ HUNT, THOMAS ] }
    DP = { id: :dp, isbn: '0201633612', name: 'Design Patterns',      publisher_id: :aw, authors: [ GAMMA, HELM, JOHNSON, VLISSIDES ] }
    CC = { id: :cc, isbn: '0735619670', name: 'Code Complete',        publisher_id: :ms, authors: [ MCCONNEL ] }

    AW = { id: :aw, name: 'Addison-Wesley',  address: LA,      books: [ PP, DP ]  }
    MS = { id: :ms, name: 'Microsoft Press', address: REDMOND, books: [ CC ]      }

    #----------------------------------------------------------------------------------------------

    class Publisher < Model
      attr :id, :name
      has_one  :address
      has_many :books
    end

    class Book < Model
      attr :isbn, :name
      belongs_to :publisher
      has_many :authors
    end

    class Author < Model
      attr :id, :name
      has_one :address
    end

    class Address < Model
      attr :id, :city, :state
    end

    #----------------------------------------------------------------------------------------------

    class PublisherSerializer < RubySerializer::Base
      expose   :id
      expose   :name
      has_one  :address
      has_many :books
    end

    class BookSerializer < RubySerializer::Base
      expose     :isbn
      expose     :name
      belongs_to :publisher
      has_many   :authors
    end

    class AuthorSerializer < RubySerializer::Base
      expose   :id
      expose   :name
      has_one  :address
    end

    class AddressSerializer < RubySerializer::Base
      expose :id
      expose :city
      expose :state
    end

    #----------------------------------------------------------------------------------------------

    def test_belongs_to
      book     = books(PP, publisher: AW)
      json     = serialize book, include: :publisher
      expected = [ :isbn, :name, :publisher_id, :publisher ]
      assert_set   expected,          json.keys
      assert_equal PP[:isbn],         json[:isbn]
      assert_equal PP[:name],         json[:name]
      assert_equal PP[:publisher_id], json[:publisher_id]
      assert_equal [ :id, :name ],    json[:publisher].keys
      assert_equal AW[:id],           json[:publisher][:id]
      assert_equal AW[:name],         json[:publisher][:name]
    end

    def test_belongs_to_but_not_included
      book     = books(PP, publisher: AW)
      json     = serialize book
      expected = [ :isbn, :name, :publisher_id ]
      assert_set   expected,          json.keys
      assert_equal PP[:isbn],         json[:isbn]
      assert_equal PP[:name],         json[:name]
      assert_equal PP[:publisher_id], json[:publisher_id]
      assert_equal nil,               json[:publisher]
    end

    #----------------------------------------------------------------------------------------------

    def test_has_one
      author   = authors(HUNT)
      json     = serialize author, include: :address
      expected = [ :id, :name, :address ]
      assert_set   expected,               json.keys
      assert_equal HUNT[:id],              json[:id]
      assert_equal HUNT[:name],            json[:name]
      assert_equal [ :id, :city, :state ], json[:address].keys
      assert_equal PORTLAND[:id],          json[:address][:id]
      assert_equal PORTLAND[:city],        json[:address][:city]
      assert_equal PORTLAND[:state],       json[:address][:state]
    end

    def test_has_one_but_not_included
      author   = authors(HUNT)
      json     = serialize author
      expected = [ :id, :name ]
      assert_set   expected,    json.keys
      assert_equal HUNT[:id],   json[:id]
      assert_equal HUNT[:name], json[:name]
      assert_equal nil,         json[:address]
    end

    #----------------------------------------------------------------------------------------------

    def test_has_many
      publisher = publishers(AW)
      json      = serialize publisher, include: :books
      expected  = [ :id, :name, :books ]
      assert_set   expected,                        json.keys
      assert_equal AW[:id],                         json[:id]
      assert_equal AW[:name],                       json[:name]
      assert_equal 2,                               json[:books].length
      assert_equal [ :isbn, :name, :publisher_id ], json[:books][0].keys
      assert_equal PP[:isbn],                       json[:books][0][:isbn]
      assert_equal PP[:name],                       json[:books][0][:name]
      assert_equal PP[:publisher_id],               json[:books][0][:publisher_id]
      assert_equal [ :isbn, :name, :publisher_id ], json[:books][1].keys
      assert_equal DP[:isbn],                       json[:books][1][:isbn]
      assert_equal DP[:name],                       json[:books][1][:name]
      assert_equal DP[:publisher_id],               json[:books][1][:publisher_id]
    end

    def test_has_many_but_not_included
      publisher = publishers(AW)
      json      = serialize publisher
      expected  = [ :id, :name ]
      assert_set   expected,         json.keys
      assert_equal AW[:id],          json[:id]
      assert_equal AW[:name],        json[:name]
      assert_equal nil,              json[:books]
    end

    #----------------------------------------------------------------------------------------------

    def test_multiple_includes
      variations = [
        [ :books, :address   ],   # verify using array of symbols
        [ 'books', 'address' ],   # verify using array of strings
          "books,address",        # verify using a comma separated string
          "  books , address "    # verify using a comma separated string (with whitespace)
      ]
      variations.each do |includes|
        publisher = publishers(AW)
        json      = serialize publisher, include: includes
        expected  = [ :id, :name, :address, :books ]
        assert_set expected, json.keys
        assert_equal AW[:id],                         json[:id]
        assert_equal AW[:name],                       json[:name]
        assert_equal [ :id, :city, :state ],          json[:address].keys
        assert_equal AW[:address][:id],               json[:address][:id]
        assert_equal AW[:address][:city],             json[:address][:city]
        assert_equal AW[:address][:state],            json[:address][:state]
        assert_equal 2,                               json[:books].length
        assert_equal [ :isbn, :name, :publisher_id ], json[:books][0].keys
        assert_equal PP[:isbn],                       json[:books][0][:isbn]
        assert_equal PP[:name],                       json[:books][0][:name]
        assert_equal PP[:publisher_id],               json[:books][0][:publisher_id]
        assert_equal [ :isbn, :name, :publisher_id ], json[:books][1].keys
        assert_equal DP[:isbn],                       json[:books][1][:isbn]
        assert_equal DP[:name],                       json[:books][1][:name]
        assert_equal DP[:publisher_id],               json[:books][1][:publisher_id]
      end
    end

    #----------------------------------------------------------------------------------------------

    def test_nested_includes
      publisher = publishers(AW)
      json      = serialize publisher, include: "books.authors.address"
      expected  = [ :id, :name, :books ]
      assert_set expected,                                    json.keys
      assert_equal AW[:id],                                   json[:id]
      assert_equal AW[:name],                                 json[:name]
      assert_equal 2,                                         json[:books].length
      assert_equal [ :isbn, :name, :publisher_id, :authors ], json[:books][0].keys
      assert_equal PP[:isbn],                                 json[:books][0][:isbn]
      assert_equal PP[:name],                                 json[:books][0][:name]
      assert_equal PP[:publisher_id],                         json[:books][0][:publisher_id]
      assert_equal 2,                                         json[:books][0][:authors].length
      assert_equal [ :id, :name, :address ],                  json[:books][0][:authors][0].keys
      assert_equal HUNT[:id],                                 json[:books][0][:authors][0][:id]
      assert_equal HUNT[:name],                               json[:books][0][:authors][0][:name]
      assert_equal [ :id, :city, :state ],                    json[:books][0][:authors][0][:address].keys
      assert_equal PORTLAND[:id],                             json[:books][0][:authors][0][:address][:id]
      assert_equal PORTLAND[:city],                           json[:books][0][:authors][0][:address][:city]
      assert_equal PORTLAND[:state],                          json[:books][0][:authors][0][:address][:state]
      assert_equal [ :id, :name, :address ],                  json[:books][0][:authors][1].keys
      assert_equal THOMAS[:id],                               json[:books][0][:authors][1][:id]
      assert_equal THOMAS[:name],                             json[:books][0][:authors][1][:name]
      assert_equal [ :id, :city, :state ],                    json[:books][0][:authors][1][:address].keys
      assert_equal BOSTON[:id],                               json[:books][0][:authors][1][:address][:id]
      assert_equal BOSTON[:city],                             json[:books][0][:authors][1][:address][:city]
      assert_equal BOSTON[:state],                            json[:books][0][:authors][1][:address][:state]
      assert_equal [ :isbn, :name, :publisher_id, :authors ], json[:books][1].keys
      assert_equal DP[:isbn],                                 json[:books][1][:isbn]
      assert_equal DP[:name],                                 json[:books][1][:name]
      assert_equal DP[:publisher_id],                         json[:books][1][:publisher_id]
      assert_equal 4,                                         json[:books][1][:authors].length
      assert_equal [ :id, :name, :address ],                  json[:books][1][:authors][0].keys
      assert_equal GAMMA[:id],                                json[:books][1][:authors][0][:id]
      assert_equal GAMMA[:name],                              json[:books][1][:authors][0][:name]
      assert_equal [ :id, :city, :state ],                    json[:books][1][:authors][0][:address].keys
      assert_equal NYC[:id],                                  json[:books][1][:authors][0][:address][:id]
      assert_equal NYC[:city],                                json[:books][1][:authors][0][:address][:city]
      assert_equal NYC[:state],                               json[:books][1][:authors][0][:address][:state]
      assert_equal [ :id, :name, :address ],                  json[:books][1][:authors][1].keys
      assert_equal HELM[:id],                                 json[:books][1][:authors][1][:id]
      assert_equal HELM[:name],                               json[:books][1][:authors][1][:name]
      assert_equal [ :id, :city, :state ],                    json[:books][1][:authors][1][:address].keys
      assert_equal SF[:id],                                   json[:books][1][:authors][1][:address][:id]
      assert_equal SF[:city],                                 json[:books][1][:authors][1][:address][:city]
      assert_equal SF[:state],                                json[:books][1][:authors][1][:address][:state]
      assert_equal [ :id, :name, :address ],                  json[:books][1][:authors][2].keys
      assert_equal JOHNSON[:id],                              json[:books][1][:authors][2][:id]
      assert_equal JOHNSON[:name],                            json[:books][1][:authors][2][:name]
      assert_equal [ :id, :city, :state ],                    json[:books][1][:authors][2][:address].keys
      assert_equal CHICAGO[:id],                              json[:books][1][:authors][2][:address][:id]
      assert_equal CHICAGO[:city],                            json[:books][1][:authors][2][:address][:city]
      assert_equal CHICAGO[:state],                           json[:books][1][:authors][2][:address][:state]
      assert_equal [ :id, :name, :address ],                  json[:books][1][:authors][3].keys
      assert_equal VLISSIDES[:id],                            json[:books][1][:authors][3][:id]
      assert_equal VLISSIDES[:name],                          json[:books][1][:authors][3][:name]
      assert_equal [ :id, :city, :state ],                    json[:books][1][:authors][3][:address].keys
      assert_equal DALLAS[:id],                               json[:books][1][:authors][3][:address][:id]
      assert_equal DALLAS[:city],                             json[:books][1][:authors][3][:address][:city]
      assert_equal DALLAS[:state],                            json[:books][1][:authors][3][:address][:state]

    end

    #----------------------------------------------------------------------------------------------

    private

    def addresses(fixture)
      Address.new(fixture)
    end

    def authors(fixture)
      author = Author.new(fixture)
      author.address = addresses(fixture[:address]) if fixture.key?(:address)
      author
    end

    def books(fixture, options = {})
      book = Book.new(fixture)
      book.publisher = publishers(options[:publisher]) if options.key?(:publisher)
      book.authors   = Array(fixture[:authors]).map { |a| authors(a) } if fixture.key?(:authors)
      book
    end

    def publishers(fixture)
      publisher = Publisher.new(fixture)
      publisher.address = addresses(fixture[:address]) if fixture.key?(:address)
      publisher.books = Array(fixture[:books]).map { |b| books(b) } if fixture.key?(:books)
      publisher
    end

    #----------------------------------------------------------------------------------------------

  end
end
