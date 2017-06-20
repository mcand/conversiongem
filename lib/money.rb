class Money
  class << self
    attr_accessor :currency, :rates
  end

  InvalidMoneyError = Class.new(StandardError)

  attr_accessor :amount, :currency

  def initialize(amount, currency)
    is_valid_amount?(amount)
    @amount = amount
    @currency = currency
  end

  def inspect
   "#{@amount} #{currency}"
  end

  def to_s
    "#{@amount} #{currency}"
  end

  def ==(money)
    return true if money.amount == @amount && money.currency == @currency
  end

  def +(money)
    if @currency != money.currency
      conversion = (money.amount / rate_for(money.currency)).round(2)
      return Money.new(@amount + conversion, @currency)
    else
      return Money.new(@amount + money.amount, money.currency)
    end
  end

  def convert_to currency
    raise InvalidMoneyError, "Currency rate not available" unless @@rates.include? currency
    raise InvalidMoneyError, "Currency base not available" unless @@currency == self.currency
    new_amount = self.amount * @@rates[currency]
    return Money.new(new_amount.round(2), currency)
  end

  def rate_for currency
    @@rates[currency]
  end

  def self.conversion_rates(currency, rates={})
    rates.values.each do |r|
     raise InvalidMoneyError, "Amount must be greater than 0" if r <= 0
    end

    @@currency = currency
    @@rates = rates
    true
  end

  private

    def is_valid_amount?(amount)
      raise InvalidMoneyError, "Amount must be greater than 0" if amount <= 0
    end

end
