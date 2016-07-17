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

    PROGRAMMING = { id: :programming, name: 'Programming', books: [ PP, DP, CC ] }

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

    class Category < Model
      attr :id, :name
      has_many :books
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

    class CategorySerializer < RubySerializer::Base
      expose   :id
      expose   :name
      has_many :books
    end

    #----------------------------------------------------------------------------------------------

    def test_belongs_to

      book    = books(PP)
      with    = serialize book, include: :publisher
      without = serialize book

      assert_book      PP, with, with: :publisher
      assert_publisher AW, with[:publisher]
      assert_book      PP, without

    end

    #----------------------------------------------------------------------------------------------

    def test_has_one

      author  = authors(HUNT)
      with    = serialize author, include: :address
      without = serialize author

      assert_author  HUNT,     with, with: :address
      assert_address PORTLAND, with[:address]
      assert_author  HUNT,     without

    end

    #----------------------------------------------------------------------------------------------

    def test_has_many

      publisher = publishers(AW)
      with      = serialize publisher, include: :books
      without   = serialize publisher

      assert_publisher AW, with, with: :books
      assert_equal     2,  with[:books].length
      assert_book      PP, with[:books][0]
      assert_book      DP, with[:books][1]
      assert_publisher AW, without

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
        assert_publisher AW, json, with: [ :address, :books ]
        assert_address   LA, json[:address]
        assert_equal     2,  json[:books].length
        assert_book      PP, json[:books][0]
        assert_book      DP, json[:books][1]
      end
    end

    #----------------------------------------------------------------------------------------------

    def test_nested_includes
      publisher = publishers(AW)
      json      = serialize publisher, include: "books.authors.address"
      assert_publisher AW,        json, with: :books
      assert_equal     2,         json[:books].length
      assert_book      PP,        json[:books][0], with: :authors
      assert_equal     2,         json[:books][0][:authors].length
      assert_author    HUNT,      json[:books][0][:authors][0],            with: :address
      assert_address   PORTLAND,  json[:books][0][:authors][0][:address]
      assert_author    THOMAS,    json[:books][0][:authors][1],            with: :address
      assert_address   BOSTON,    json[:books][0][:authors][1][:address]
      assert_book      DP,        json[:books][1],                         with: :authors
      assert_equal     4,         json[:books][1][:authors].length
      assert_author    GAMMA,     json[:books][1][:authors][0],            with: :address
      assert_address   NYC,       json[:books][1][:authors][0][:address]
      assert_author    HELM,      json[:books][1][:authors][1],            with: :address
      assert_address   SF,        json[:books][1][:authors][1][:address]
      assert_author    JOHNSON,   json[:books][1][:authors][2],            with: :address
      assert_address   CHICAGO,   json[:books][1][:authors][2][:address]
      assert_author    VLISSIDES, json[:books][1][:authors][3],            with: :address
      assert_address   DALLAS,    json[:books][1][:authors][3][:address]
    end

    #----------------------------------------------------------------------------------------------

    def test_multiple_nested_includes
      category = categories(PROGRAMMING)
      json     = serialize category, include: "books.publisher, books.authors"
      assert_category  PROGRAMMING, json, with: :books
      assert_equal     3,           json[:books].length
      assert_book      PP,          json[:books][0], with: [ :publisher, :authors ]
      assert_publisher AW,          json[:books][0][:publisher]
      assert_equal     2,           json[:books][0][:authors].length
      assert_author    HUNT,        json[:books][0][:authors][0]
      assert_author    THOMAS,      json[:books][0][:authors][1]
      assert_book      DP,          json[:books][1], with: [ :publisher, :authors ]
      assert_publisher AW,          json[:books][1][:publisher]
      assert_equal     4,           json[:books][1][:authors].length
      assert_author    GAMMA,       json[:books][1][:authors][0]
      assert_author    HELM,        json[:books][1][:authors][1]
      assert_author    JOHNSON,     json[:books][1][:authors][2]
      assert_author    VLISSIDES,   json[:books][1][:authors][3]
      assert_book      CC,          json[:books][2], with: [ :publisher, :authors ]
      assert_publisher MS,          json[:books][2][:publisher]
      assert_equal     1,           json[:books][2][:authors].length
      assert_author    MCCONNEL,    json[:books][2][:authors][0]
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

    def books(fixture)
      book = Book.new(fixture)
      book.publisher = publishers(fixture[:publisher_id], false)
      book.authors   = Array(fixture[:authors]).map { |a| authors(a) } if fixture.key?(:authors)
      book
    end

    def publishers(fixture, include_books = true)
      fixture = AW if fixture == :aw
      fixture = MS if fixture == :ms
      publisher = Publisher.new(fixture)
      publisher.address = addresses(fixture[:address]) if fixture.key?(:address)
      publisher.books = Array(fixture[:books]).map { |b| books(b) } if include_books && fixture[:books]
      publisher
    end

    def categories(fixture)
      category = Category.new(fixture)
      category.books = Array(fixture[:books]).map { |b| books(b) } if fixture.key?(:books)
      category
    end

    #----------------------------------------------------------------------------------------------

    def assert_publisher(expected, actual, options = {})
      expected_keys = [ :id, :name ] + Array(options[:with])
      assert_set   expected_keys,   actual.keys
      assert_equal expected[:id],   actual[:id]
      assert_equal expected[:name], actual[:name]
    end

    def assert_book(expected, actual, options = {})
      expected_keys = [ :isbn, :name, :publisher_id ] + Array(options[:with])
      assert_set   expected_keys,           actual.keys
      assert_equal expected[:isbn],         actual[:isbn]
      assert_equal expected[:name],         actual[:name]
      assert_equal expected[:publisher_id], actual[:publisher_id]
    end

    def assert_author(expected, actual, options = {})
      expected_keys = [ :id, :name ] + Array(options[:with])
      assert_set   expected_keys,   actual.keys
      assert_equal expected[:id],   actual[:id]
      assert_equal expected[:name], actual[:name]
    end

    def assert_address(expected, actual)
      assert_set   [ :id, :city, :state ], actual.keys
      assert_equal expected[:id],          actual[:id]
      assert_equal expected[:city],        actual[:city]
      assert_equal expected[:state],       actual[:state]
    end

    def assert_category(expected, actual, options = {})
      expected_keys = [ :id, :name ] + Array(options[:with])
      assert_equal expected_keys,   actual.keys
      assert_equal expected[:id],   actual[:id]
      assert_equal expected[:name], actual[:name]
    end

    #----------------------------------------------------------------------------------------------

  end
end
