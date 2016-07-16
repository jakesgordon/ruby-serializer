module RubySerializer
  class Field

    attr_reader :field, :as, :from, :value, :namespace

    def initialize(field, namespace, options)
      @field     = field.to_sym
      @as        = options[:as]   || field
      @from      = options[:from] || field
      @value     = options[:value]
      @only      = options[:only]
      @unless    = options[:unless]
      @namespace = namespace.dup
    end

    def serialize(resource, serializer)
      case value
      when nil    then resource.send(from)
      when Symbol then resource.send(value)
      when Proc   then serializer.instance_exec(&value)
      else
        value
      end
    end

    def present?(resource, serializer)
      only?(resource, serializer) && !unless?(resource, serializer)
    end

    def only?(resource, serializer)
      case @only
      when nil    then true
      when true   then true
      when false  then false
      when Symbol then resource.send(@only)
      when Proc   then serializer.instance_exec(&@only)
      else
        raise ArgumentError, "unexpected #{@only}"
      end
    end

    def unless?(resource, serializer)
      case @unless
      when nil    then false
      when true   then true
      when false  then false
      when Symbol then resource.send(@unless)
      when Proc   then serializer.instance_exec(&@unless)
      else
        raise ArgumentError, "unexpected #{@unless}"
      end
    end

  end
end
