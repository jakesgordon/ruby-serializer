module Namespaced
  class BookSerializer < RubySerializer::Base

    expose :id
    expose :name
    expose :isbn

  end
end
