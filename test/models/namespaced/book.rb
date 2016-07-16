module Namespaced
  class Book

    attr_accessor :id,
                  :name,
                  :isbn

    def initialize(options = {})
      @id   = options[:id]
      @name = options[:name]
      @isbn = options[:isbn]
    end

  end
end
