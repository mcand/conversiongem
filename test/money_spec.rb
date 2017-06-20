require 'minitest/autorun'
require 'conversion_dawanda'
require 'money'

describe Money do
  let(:fifty_eur) {Money.new(50, 'EUR')}
  let(:twenty_eur) {Money.new(20, 'EUR')}
  let(:invalid_eur) {Money.new(-1, 'EUR')}
  let(:invalid_base) {Money.new(50, 'BR')}
  let(:twenty_dollars) {Money.new(20, 'USD')}

  describe "Money creation" do
    it "is possible to create a money with a valid amount and a valid currency" do
      fifty_eur.amount.must_equal 50
      fifty_eur.currency.must_equal 'EUR'
    end

    it "is not possible to create a money with an invalid amount" do
      err = -> { Money.new(0, 'EUR') }.must_raise Money::InvalidMoneyError
      err.message.must_match(/Amount must be greater than 0/)
    end
  end

  describe "Money inspection" do
    it "is possible to inspect an instance to get the amount and currency" do
      fifty_eur.inspect.must_equal "#{fifty_eur.amount} #{fifty_eur.currency}"
    end
  end

  describe "Money configuration" do
    it "is possible to configure currency rates with respect to a base currency" do
      conversion_rates = Money.conversion_rates('EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047 })
      conversion_rates.must_equal true
    end

    it "is not possible to configure a currency rate with an invalid amount of currency" do
      err = -> { Money.conversion_rates('EUR', { 'USD' => -1.11, 'Bitcoin' => -0.0047 })}.must_raise Money::InvalidMoneyError
      err.message.must_match(/Amount must be greater than 0/)
    end
  end

  describe "Money convertion" do
    it "is possible to convert to a different currency" do
      fifty_eur.convert_to('USD').amount.must_equal 55.50
      fifty_eur.convert_to('USD').currency.must_equal 'USD'
    end

    it "should return a Money instance when convert is called" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      fifty_eur.convert_to('USD').must_be_instance_of Money
    end

    it "is not possible to convert an invalid amount" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      err = -> { invalid_eur.convert_to('USD')}.must_raise Money::InvalidMoneyError
      err.message.must_match(/Amount must be greater than 0/)
    end

    it "is not possible to convert to a currency rate that is not configured" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      err = -> { fifty_eur.convert_to('BR')}.must_raise Money::InvalidMoneyError
      err.message.must_match(/Currency rate not available/)
    end

    it "is not possible to convert to a currency if the currency base is not valid" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      err = -> { invalid_base.convert_to('USD')}.must_raise Money::InvalidMoneyError
      err.message.must_match(/Currency base not available/)
    end
  end

  describe "Arithmetics" do
    describe "Sum" do
      it "is possible to sum two instances of money" do
        Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
        sum = fifty_eur + fifty_eur
        sum.must_equal(Money.new(100, 'EUR'))
      end

      it "is possible to sum two instances of money" do
        Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
        sum = fifty_eur + twenty_eur
        sum.must_equal(Money.new(70, 'EUR'))
      end

      it "is possible to sum two instances of money with different currencies" do
        Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
        sum = fifty_eur + twenty_dollars
        sum.must_equal(Money.new(68.02, 'EUR'))
      end
    end
  end

  describe "Subtraction" do
    it "is possibe to subtract two instances of money" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      minus = fifty_eur - twenty_eur
      minus.must_equal(Money.new(30.0, 'EUR'))
    end

    it "is possible to subtract two instances of money with different currencies" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      minus = fifty_eur - twenty_dollars
      minus.must_equal(Money.new(31.98, 'EUR'))
    end
  end

  describe "Division" do
    it "is possible to divide a money instance by a number" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      result = fifty_eur / 2
      result.must_equal(Money.new(25, 'EUR'))
    end

    it "should not be possible to divide a money with anything but a number" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      err = -> { fifty_eur / twenty_eur }.must_raise Money::InvalidMoneyError
      err.message.must_match(/Divistion not permited/)
    end
  end

  describe "Multiplication" do
    it "should be possible to mukltiplicate a money by a number" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      result = twenty_dollars * 3
      result.must_equal(Money.new(60, 'USD'))
    end

    it "should not be possible to multiplicate a money with anything but a number" do
      Money.conversion_rates('EUR', { 'USD'=> 1.11, 'Bitcoin' => 0.0047})
      err = -> { fifty_eur * twenty_eur }.must_raise Money::InvalidMoneyError
      err.message.must_match(/Multiplication not permited/)
    end
  end
end
