module RubySerializer
  class Base

    extend RubySerializer::Dsl

    attr_reader :scope
    attr_reader :options, :include # only populated during #serialize and (temporarily) stores the #serialize options to make
                                   # them available to any potential :value, :only and :unless lambdas in the derived serializer

    def initialize(resource, scope)
      @resource = resource
      @scope    = scope
    end

    def serialize(options = {})
      if resource.respond_to? :to_ary
        serialize_array(options)
      else
        serialize_object(options)
      end
    end

    #----------------------------------------------------------------------------------------------
    # PRIVATE implementation
    #----------------------------------------------------------------------------------------------

    private

    attr_reader :resource

    def serialize_array(options)
      raise NotImplementedError
    end

    def serialize_object(options)
      json = {}
      self.class.fields.each do |field|
        key = field.as
        ns  = namespace(field, json)
        ns[key] = field.serialize(resource, self)
      end
      json
    end

    def namespace(field, json)
      field.namespace.reduce(json) { |ns, name| ns[name] ||= {} }
    end

    #----------------------------------------------------------------------------------------------

  end
end
