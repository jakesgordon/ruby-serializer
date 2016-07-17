module RubySerializer
  class Association < Field

    #----------------------------------------------------------------------------------------------

    def serialize(resource, serializer)
      association = resource.send(field)
      if association
        RubySerializer.as_json(association)
      end
    end

    #----------------------------------------------------------------------------------------------

    def present?(resource, serializer)
      super &&
      serializer.send(:include?, field)
    end

    #----------------------------------------------------------------------------------------------

  end
end
