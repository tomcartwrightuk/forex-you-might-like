class ExchangeRatesController < ApplicationController
  def index
    @currencies = Exchange.uniq.pluck(:currency)
    if params[:date]
      @parsed_date = Date.parse(params[:date], "%Y=%m-%d")
      begin
        @amount = BigDecimal(params[:amount])
        rate = Fx::ExchangeRate.at(@parsed_date,
                            params[:from_currency],
                            params[:to_currency])
        @converted_rate = rate * @amount
      rescue ActiveRecord::RecordNotFound
        flash.now[:error] = "So sorry - we don't have rates for those dates"
      end
    end
  end
end
