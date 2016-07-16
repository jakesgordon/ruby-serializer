module RubySerializer
  class Field

    attr_reader :field, :as, :value, :namespace

    def initialize(field, namespace, options)
      @field     = field.to_sym
      @as        = options[:as] || field
      @value     = options[:value]
      @only      = options[:only]
      @unless    = options[:unless]
      @namespace = namespace.dup
    end

    def serialize(resource, serializer)
      case value
      when nil    then resource.send(field)
      when Symbol then resource.send(value)
      when Proc   then serializer.instance_exec(&value)
      else
        value
      end
    end

  end
end
