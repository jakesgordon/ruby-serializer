module RubySerializer
  class Base

    extend RubySerializer::Dsl

    attr_reader :options

    def initialize(resource)
      @resource = resource
    end

    def as_json(options = {})
      json = serialize(options)
      json = { options[:root] => json } if options[:root]
      json
    end

    #----------------------------------------------------------------------------------------------
    # PRIVATE implementation
    #----------------------------------------------------------------------------------------------

    private

    attr_reader :resource
    attr_reader :includes

    def include?(association)
      includes.include?(association.to_sym)
    end

    def serialize(options = {})
      if resource.respond_to? :to_ary
        serialize_array(options)
      else
        serialize_object(options)
      end
    end

    def serialize_array(options)
      resource.map do |item|
        serializer = RubySerializer.build(item)
        serializer.send :serialize, options.merge(root: nil)
      end
    end

    def serialize_object(options)
      @options  = options
      @includes = expand_includes(options[:include])
      json = {}
      json[:errors] = resource.errors if resource.respond_to?(:valid?) && !resource.valid?
      self.class.fields.each do |field|
        next unless field.present?(resource, self)
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

    def expand_includes(includes, options = {})
      sanitize_includes(includes)
    end

    def sanitize_includes(includes)
      includes = case includes
                 when nil then []
                 when Array then includes
                 when Symbol then [ includes ]
                 when String then includes.split(',')
                 else
                   raise ArgumentError, "unexpected includes #{includes.class}"
                 end
      includes.map { |i| i.to_s.downcase.strip.to_sym }
    end

    #----------------------------------------------------------------------------------------------

  end
end
