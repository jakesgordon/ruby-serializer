class CompanySerializer < RubySerializer::Base

  expose :id
  expose :name
  expose :url, as: :website

end
