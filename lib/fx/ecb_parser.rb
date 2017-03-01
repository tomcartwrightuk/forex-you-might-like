require 'bigdecimal'
require 'nokogiri'

module Fx
  class EcbParser < FxParser
    FX_RATE_URL = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml?7c51b651fcfbe9ec05e40ce73e1c9153"

    def self.parse(fx_xml)
      rates = []
      doc = Nokogiri::XML(fx_xml)
      days = doc.xpath("//*[@time]")
      days.each do |day|
        date = Date.parse(day.attr('time'), '%Y-%m-%d')
        currencies = day.xpath(".//*[@rate]")
        currencies.each do |cur|
          rates.push({
            date: date,
            currency: cur.attr('currency'),
            rate: BigDecimal(cur.attr('rate')),
          })
        end
      end
      rates
    end
  end
end
