module RubySerializer

  #------------------------------------------------------------------------------------------------

  VERSION     = '0.0.1'
  SUMMARY     = 'Serialize POROs to JSON'
  DESCRIPTION = 'A general purpose library for serializing plain old ruby objects (POROs) into JSON using a declarative DSL'
  LIB         = File.dirname(__FILE__)

  autoload :JSON, File.join(LIB, 'ruby_serializer/json')

  #------------------------------------------------------------------------------------------------

end
