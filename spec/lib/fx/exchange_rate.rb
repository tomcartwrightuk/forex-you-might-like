require "spec_helper"

describe Fx::ExchangeRate do
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
  let(:parser) { double(parse: rates) }

  describe ".import" do
    it "should pass rate to store" do
      store = double()
      exchange = Fx::ExchangeRate.new(store, parser: parser)
      expect(store).to receive(:store_rates)
      exchange.import
    end
  end

  describe "#rate_at" do
    context "successful conversion" do
      it "it should convert between non-euro currencies" do
        store = double()
        allow(store).to receive(:rate_at).and_return(usd_rate, gbp_rate)
        exchange = Fx::ExchangeRate.new(store, parser: parser)

        rate = exchange.rate_at(Date.new, 'USD', 'GBP')

        expect(rate).to eq(BigDecimal('1.2424'))
      end

      it 'should convert between reference currency and non-ref currencies' do
        store = double()
        allow(store).to receive(:rate_at).and_return(usd_rate)
        exchange = Fx::ExchangeRate.new(store, parser: parser)

        rate = exchange.rate_at(Date.new, 'EUR', 'USD')

        expect(rate).to eq(BigDecimal('0.9389'))
      end

      it 'should convert between non-reference currency and the ref currency' do
        store = double()
        allow(store).to receive(:rate_at).and_return(usd_rate)
        exchange = Fx::ExchangeRate.new(store, parser: parser)

        rate = exchange.rate_at(Date.new, 'USD', 'EUR')

        expect(rate).to eq(BigDecimal('1.065'))
      end
    end

    context "unsucessful conversion" do
      it "should raise an exception if a rate does not exist"

    end
  end
end
