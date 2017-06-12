class Money
  InvalidMoneyError = Class.new(StandardError)

  attr_accessor :amount, :currency
  
  def initialize(amount, currency)
    raise InvalidMoneyError, "Amount must be greater than 0" if amount <= 0
    @amount = amount
    @currency = currency
  end
 
end

