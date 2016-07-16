class User

  attr_accessor :id,
                :name,
                :email,
                :initials,
                :timezone,
                :locale,
                :superuser,
                :company

  def initialize(options = {})
    @id        = options[:id]
    @name      = options[:name]
    @email     = options[:email]
    @initials  = options[:initials]
    @timezone  = options[:timezone]
    @locale    = options[:locale]
    @superuser = options[:superuser]
    @company   = options[:company]
  end

end
