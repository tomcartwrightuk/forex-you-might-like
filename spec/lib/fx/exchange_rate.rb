require 'spec_helper'

describe Fx::ExchangeRate do
  describe ".import" do
    it 'should pass rate to store' do
      rates = [{
        date: Date.new(2017, 1, 1),
        currency: 'USD',
        rate: BigDecimal('1.5')
      }, {
        date: Date.new(2017, 1, 1),
        currency: 'GBP',
        rate: BigDecimal('0.8')
      }]
      parser = double(parse: rates)
      store = double()
      exchange = Fx::ExchangeRate.new(store, parser)
      expect(store).to receive(:store_day_rates)
      exchange.import
    end
  end
end
