require 'bigdecimal'
require 'nokogiri'

class EcbParser < FxParser
  FX_RATE_URL = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"

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
