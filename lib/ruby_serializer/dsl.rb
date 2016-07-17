module RubySerializer
  module Dsl

    #----------------------------------------------------------------------------------------------

    def serializes(name)
      define_method(name) do   # provide a friendly-name accessor to the underlying resource
        resource
      end
    end

    def expose(field, options = {})
      fields << Field.new(field, namespace, options)
    end

    def belongs_to(field, options = {})
      fields << Field.new("#{field}_id", namespace, options)
      fields << Association.new(field, namespace, options)
    end

    def namespace(ns = nil, &block)
      @namespace ||= []
      return @namespace if ns.nil?  # this method acts as both getter (this line) and setter (subsequent)
      @namespace.push(ns)
      block.call(binding)
      @namespace.pop
    end

    def fields
      @fields ||= []
    end

    #----------------------------------------------------------------------------------------------

  end
end
