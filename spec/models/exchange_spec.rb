require 'rails_helper'

describe Exchange do
  it "is valid with valid attributes" do
    exchange = Exchange.new(currency: 'USD', rate: BigDecimal('0.8'), date: Date.new)
    expect(exchange).to be_valid
  end

  it "is not valid without a rate" do
    exchange = Exchange.new(currency: 'USD', date: Date.new)
    expect(exchange).to_not be_valid
  end

  it "is not valid without a currency" do
    exchange = Exchange.new(rate: BigDecimal('0.8'), date: Date.new)
    expect(exchange).to_not be_valid
  end

  it "is not valid without a date" do
    exchange = Exchange.new(currency: 'USD', rate: BigDecimal('0.8'))
    expect(exchange).to_not be_valid
  end

  # TODO test valid date is a valid Date object, rate is a valid decimal
  # and inclusion of currencies in a list of valid currencies and uniqueness
  # constraints

  # the following rate vars could be reused from before but if the format of
  # data passed to store rates changes, it's best to define that here. Plus, you
  # don't have to look in other files!
  describe ".store_rates" do
    let (:usd_rate) { BigDecimal('1.065') }
    let (:gbp_rate) { BigDecimal('0.8572') }
    let(:rates) {
      [{
        date: Date.new(2017, 1, 1),
        currency: 'USD',
        rate: usd_rate
      }, {
        date: Date.new(2017, 1, 1),
        currency: 'GBP',
        rate: gbp_rate
      }]
    }

    it "should store an array of valid rates" do
      Exchange.store_rates(rates)
      expect(Exchange.count).to eq 2
    end

    it "should ignore duplicate rates" do
      Exchange.store_rates(rates)
      duped_rates = rates.push({
        date: Date.new(2017, 2, 1),
        currency: 'USD',
        rate: usd_rate
      })

      expect {
        Exchange.store_rates(duped_rates)
      }.to change{ Exchange.count }.by 1
    end

    it "should throw an exception if a rate is invalid" do
      bad_rate = rates
      bad_rate[0][:currency] = nil

      expect {
        Exchange.store_rates(rates)
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Exchange.count).to eq 0
    end
  end

  describe ".rate_at" do
    let(:usd_rate) {
      {
        date: Date.new(2017, 1, 1),
        currency: 'USD',
        rate: BigDecimal('1.065')
      }
    }
    let (:usd) { Exchange.new(usd_rate) }

    it "should return a rate for a given currency and date" do
      allow(Exchange).to receive(:find_by_date_and_currency!).and_return(usd)

      returned_rate = Exchange.rate_at(usd_rate[:date], usd_rate[:currency])
      expect(returned_rate).to eq(usd)
    end

    # This raises exception so that the consuming lib could create a null
    # ExchangeRate object or similar
    it "should return raise RecordNotFound for non-existent date" do
      expect {
        Exchange.rate_at(Date.new, 'EUR')
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
