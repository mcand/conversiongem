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
    zero_eur = Money.new(0, 'EUR')
    zero_eur.ex
  end
end
