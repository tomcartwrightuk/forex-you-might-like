class Exchange < ActiveRecord::Base
  validates_presence_of :date, :rate, :currency

  def self.store_rates(rates)
    rates.uniq.each do |rate|
      rate_exists = find_by_date_and_currency(rate[:date], rate[:currency])
      unless rate_exists
        create!(rate)
        logger.info "Importing #{rate.inspect}"
      end
    end
  end

  def self.rate_at(date, currency)
    find_by_date_and_currency!(date, currency).rate
  end
end
