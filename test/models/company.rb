class Company

  attr_accessor :id,
                :name,
                :users

  def initialize(options = {})
    @id    = options[:id]
    @name  = options[:name]
    @users = Array(options[:users])
  end

end
