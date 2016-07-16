module Namespaced
  class BookSerializer < RubySerializer::JSON

    expose :id
    expose :name
    expose :isbn

  end
end
