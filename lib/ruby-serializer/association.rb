module RubySerializer
  class Association < Field

    #----------------------------------------------------------------------------------------------

    def serialize(resource, serializer)
      includes = serializer.send(:includes)[field]
      association = resource.send(field)
      if association
        RubySerializer.as_json(association, include: includes)
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
