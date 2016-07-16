class Company

  attr_accessor :id,
                :name,
                :url,
                :users

  def initialize(options = {})
    @id    = options[:id]
    @name  = options[:name]
    @url   = options[:url]
    @users = Array(options[:users])
  end

end
