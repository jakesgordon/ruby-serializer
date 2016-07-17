module RubySerializer

  #------------------------------------------------------------------------------------------------

  VERSION     = '1.0.1'
  SUMMARY     = 'Serialize POROs to JSON'
  DESCRIPTION = 'A general purpose library for serializing plain old ruby objects (POROs) into JSON using a declarative DSL'
  LIB         = File.dirname(__FILE__)

  #------------------------------------------------------------------------------------------------

  autoload :Dsl,         File.join(LIB, 'ruby-serializer/dsl')
  autoload :Base,        File.join(LIB, 'ruby-serializer/base')
  autoload :Field,       File.join(LIB, 'ruby-serializer/field')
  autoload :Association, File.join(LIB ,'ruby-serializer/association')

  #------------------------------------------------------------------------------------------------

  def self.build(resource, options = {})
    serializer_class = options[:with] || options[:serializer] || detect_serializer(resource)
    serializer_class.new(resource)
  end

  #------------------------------------------------------------------------------------------------

  def self.as_json(resource, options = {})
    build_options = {
      with:       options.delete(:with),
      serializer: options.delete(:serializer)
    }
    build(resource, build_options).as_json(options)
  end

  #------------------------------------------------------------------------------------------------

  def self.detect_serializer(resource)
    return RubySerializer::Base if resource.respond_to?(:to_ary)
    namespace = resource.class.name.split("::")
    scope   = Kernel.const_get namespace[0...-1].join("::") if namespace.length > 1
    scope ||= Kernel
    name = namespace.last
    scope.const_get "#{name}Serializer"
  end

  #------------------------------------------------------------------------------------------------

end
