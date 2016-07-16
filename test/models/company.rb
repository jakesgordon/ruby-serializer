class Company

  attr_accessor :id,
                :name,
                :url,
                :headquarters,
                :ticker,
                :price,
                :cap,
                :ceo

  def initialize(options = {})
    @id           = options[:id]
    @name         = options[:name]
    @url          = options[:url]
    @headquarters = options[:headquarters]
    @ticker       = options[:ticker]
    @price        = options[:price]
    @cap          = options[:cap]
    @ceo          = options[:ceo]
  end

end
