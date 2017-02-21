module Fx
  class ExchangeRate
    def initialize(store, ref_currency: 'EUR', parser: Fx::EcbParser)
      @store = store
      @parser = parser
      @ref_currency = ref_currency
    end

    def self.at(date, from, to)
      new(default_store).rate_at(date, from, to)
    end

    def import(rate_xml)
      day_rates = @parser.parse(rate_xml)
      @store.store_rates(day_rates)
    end

    def rate_at(date, from_currency, to_currency)
      from_rate = retrieve_rate(date, from_currency)
      to_rate = retrieve_rate(date, to_currency)
      (from_rate / to_rate).truncate(4)
    end

    private

    def self.default_store
      Exchange
    end

    def retrieve_rate(date, currency)
      if currency == @ref_currency
        BigDecimal('1.0')
      else
        @store.rate_at(date, currency)
      end
    end

  end
end
