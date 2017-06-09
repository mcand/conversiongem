require 'minitest/autorun'
require 'conversion_dawanda'

describe Money do 
  it "is possible to create a money" do
    fifty_eur = Money.new(50, 'EUR')
    fifty_eur.value.must_equal 50
  end
end
