module RubySerializer
  class Model   # simple model with ActiveRecord like associations

    def initialize(attributes = {})
      @valid  = true
      @errors = []
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end

    def valid?
      @valid
    end

    def errors
      @errors
    end

    def self.belongs_to(key)
      idkey     = "#{key}_id"
      instvar   = "@#{key}"
      idinstvar = "@#{idkey}"
      define_method key do
        instance_variable_get instvar
      end
      define_method idkey do
        instance_variable_get idinstvar
      end
      define_method "#{key}=" do |value|
        instance_variable_set instvar,   value
        instance_variable_set idinstvar, value ? value.id : nil
      end
    end

  end
end
