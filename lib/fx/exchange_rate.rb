module Fx
  class ExchangeRate
    def initialize(store, parser = Fx::EcbParser)
      @store = store
      @parser = parser
    end

    def self.at(date, from, to)
      new(default_store).rate_at(from, to)
    end

    def import
      day_rates = @parser.parse
      @store.store_day_rates(day_rates)
    end

    def rate_at(date, from_currency, to_currency)
      base_rate = @store.rate_at(date, from_currency)
      to_rate = @store.rate_at(date, to_currency)
      (base_rate / to_rate).truncate(4)
    end

    private

    def default_store(*args)

    end
  end
end
