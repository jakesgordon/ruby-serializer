module RubySerializer
  class JSON

    def initialize(resource, options = {})
    end

    def as_json
      { id: 42, name: 'Jake Gordon' }
    end

    def self.expose(attribute, options = {})
    end

  end
end
