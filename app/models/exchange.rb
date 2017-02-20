class Exchange < ActiveRecord::Base
  validates_presence_of :date, :rate, :currency

  def self.store_rates(rates)
    create!(rates)
  end

  def self.rate_at(date, currency)
    find_by_date_and_currency!(date, currency)
  end
end
