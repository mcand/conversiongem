class Money
  attr_accessor :amount, :currency
  
  def initialize(amount, currency)
    self.amount = amount
    self.currency = currency;
  end
 
end
