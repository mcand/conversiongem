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
    return "#{@amount} #{currency}"
  end

  def convert_to currency
    # TODO: verificar se ta setado para o currency passado
    # TODO: verificar se tem o que o cara quer converter
    puts "#{self.amount}"
    new_amount = self.amount * @@rates[currency]
    return Money.new(new_amount.round(2), currency)
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

