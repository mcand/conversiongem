require 'minitest/autorun'
require 'conversion_dawanda'
require 'money'

describe Money do 
  it "is possible to create a money with a valid amount and a valid currency" do
    fifty_eur = Money.new(50, 'EUR')
    fifty_eur.amount.must_equal 50
    fifty_eur.currency.must_equal 'EUR'
  end

  it "is not possible to create a money with an invalid amount" do
    err = -> { Money.new(0, 'EUR') }.must_raise Money::InvalidMoneyError
    err.message.must_match /Amount must be greater than 0/
  end

  it "is possible to inspect an instance to get the amount and currency" do
    fifty_eur = Money.new(50, 'EUR')
    fifty_eur.inspect.must_equal "#{fifty_eur.amount} #{fifty_eur.currency}" 
  end
end
