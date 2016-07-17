module RubySerializer

  #------------------------------------------------------------------------------------------------

  VERSION     = '0.0.1'
  SUMMARY     = 'Serialize POROs to JSON'
  DESCRIPTION = 'A general purpose library for serializing plain old ruby objects (POROs) into JSON using a declarative DSL'
  LIB         = File.dirname(__FILE__)

  #------------------------------------------------------------------------------------------------

  autoload :Dsl,   File.join(LIB, 'ruby_serializer/dsl')
  autoload :Base,  File.join(LIB, 'ruby_serializer/base')
  autoload :Field, File.join(LIB, 'ruby_serializer/field')

  #------------------------------------------------------------------------------------------------

  def self.build(resource, options = {})
    serializer_class = options[:with] || options[:serializer] || detect_serializer(resource)
    serializer_class.new(resource, options[:scope])
  end

  #------------------------------------------------------------------------------------------------

  def self.serialize(resource, options = {})
    build_options = {
      with:       options.delete(:with),
      serializer: options.delete(:serializer),
      scope:      options.delete(:scope)
    }
    build(resource, build_options).serialize(options)
  end

  #------------------------------------------------------------------------------------------------

  def self.detect_serializer(resource, scope = nil)
    return RubySerializer::Base if resource.respond_to?(:to_ary)
    namespace = resource.class.name.split("::")
    scope ||= Kernel.const_get namespace[0...-1].join("::") if namespace.length > 1
    scope ||= Kernel
    name = namespace.last
    scope.const_get "#{name}Serializer"
  end

  #------------------------------------------------------------------------------------------------

end
