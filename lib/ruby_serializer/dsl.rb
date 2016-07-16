module RubySerializer
  module Dsl

    def expose(field, options = {})
      fields << Field.new(field, namespace, options)
    end

    def fields
      @fields ||= []
    end

    def namespace(ns = nil, &block)
      @namespace ||= []
      return @namespace if ns.nil?  # this method acts as both getter (this line) and setter (subsequent)
      @namespace.push(ns)
      block.call(binding)
      @namespace.pop
    end

  end
end
