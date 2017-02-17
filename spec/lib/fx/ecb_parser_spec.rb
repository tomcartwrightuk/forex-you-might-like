require 'spec_helper'

describe Fx::EcbParser do
  describe "#parse" do
    context "parsable file" do
      it "should return an array of exchange rates" do
        xml_doc = File.open("spec/fixtures/ecb-res.xml")
        res = Fx::EcbParser.parse(xml_doc)
        expect(res).to include({
          date: Date.new(2017,2,15),
          currency: "USD",
          rate: BigDecimal("1.0555")
        })
        expect(res.length).to eq 4
      end
    end

    context "unparseable file" do
      it "should raise error for unparsable date"
      it "should raise error for unparsable rate"
      it "should raise missing data error for"
    end
  end
end
