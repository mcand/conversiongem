require 'minitest/autorun'
require 'conversion_dawanda'
require 'money'

describe Money do 
  let(:fifty_eur) {Money.new(50, 'EUR')}

  it "is possible to create a money with a valid amount and a valid currency" do
    fifty_eur.amount.must_equal 50
    fifty_eur.currency.must_equal 'EUR'
  end

  it "is not possible to create a money with an invalid amount" do
    err = -> { Money.new(0, 'EUR') }.must_raise Money::InvalidMoneyError
    err.message.must_match /Amount must be greater than 0/
  end

  it "is possible to inspect an instance to get the amount and currency" do
    fifty_eur.inspect.must_equal "#{fifty_eur.amount} #{fifty_eur.currency}" 
  end

  it "is possible to configure currency rates with respect to a base currency" do
    conversion_rates = Money.conversion_rates('EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047 })
    conversion_rates.must_equal true
  end

  it "is not possible to configure a currency rate with an invalid amount of currency" do
    err = -> { Money.conversion_rates('EUR', { 'USD' => -1.11, 'Bitcoin' => -0.0047 })}.must_raise Money::InvalidMoneyError
    err.message.must_match /Amount must be greater than 0/
  end

  it "is possible to convert to a different currency" do
    Money.conversion_rates('EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047})
    fifty_eur.convert_to('USD').amount.must_equal 55.50
    fifty_eur.convert_to('USD').currency.must_equal 'USD'
  end

  it "should return a Money instance when convert is called" do
    Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
    fifty_eur.convert_to('USD').must_be_instance_of Money
  end

  it "is not possible to convert an invalid amount" do
  end

end
