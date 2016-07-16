module RubySerializer

  #------------------------------------------------------------------------------------------------

  VERSION     = '0.0.1'
  SUMMARY     = 'Serialize POROs to JSON'
  DESCRIPTION = 'A general purpose library for serializing plain old ruby objects (POROs) into JSON using a declarative DSL'
  LIB         = File.dirname(__FILE__)

  autoload :JSON, File.join(LIB, 'ruby_serializer/json')

  #------------------------------------------------------------------------------------------------

  def self.serialize(resource, options = {})
    { id: 42, name: 'Jake Gordon' }
  end

  def self.serializer(resource, scope = nil)
    namespace = resource.class.name.split("::")
    scope ||= Kernel.const_get namespace[0...-1].join("::") if namespace.length > 1
    scope ||= Kernel
    name = namespace.last
    scope.const_get "#{name}Serializer"
  end

  #------------------------------------------------------------------------------------------------

end
