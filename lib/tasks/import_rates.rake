require 'open-uri'

# TODO handle timeouts. Move to own lib function importer or similar. Write tests etc
task :import_rates => :environment do |task, args|
  rate_doc = open(Fx::EcbParser::FX_RATE_URL)
  exchange_rate = Fx::ExchangeRate.new(Exchange, ref_currency: 'EUR', parser: Fx::EcbParser)
  exchange_rate.import(rate_doc)
end
