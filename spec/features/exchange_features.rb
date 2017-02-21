require 'rails_helper'

feature "exchange features" do
  let(:gbp) {
    {
      date: Date.new(2017, 1, 1),
      currency: 'EUR',
      rate: BigDecimal('1.25')
    }
  }
  let(:usd) {
    {
      date: Date.new(2017, 1, 1),
      currency: 'USD',
      rate: BigDecimal('1')
    }
  }
  let (:gbp_rate) { Exchange.new(gbp) }
  let (:usd_rate) { Exchange.new(usd) }

  # These scenarios stub the rails finder methods. I would probably create a
  # scenerio or two that did an import and stored records in the db for a full
  # end-to-end test

  scenario 'User successfull asks for conversion' do
    allow(Exchange).to receive(:find_by_date_and_currency!)
      .and_return(gbp_rate, usd_rate)
    allow(Exchange).to receive_message_chain(:uniq, :pluck)
      .and_return(['USD', 'GBP'])

    visit '/exchange_rates'
    save_and_open_page
    page.select 'GBP', from: 'from_currency'
    page.select 'USD', from: 'to_currency'
    page.fill_in 'date', with: '2017-02-21'
    click_button 'Convert'

    expect(page).to have_text("1.25")
    expect(page).to have_text("GBP")
    expect(page).to have_text("USD")
  end

  scenario 'User unsuccessfull asks for conversion' do
    allow(Exchange).to receive_message_chain(:uniq, :pluck)
      .and_return(['USD', 'GBP'])

    visit '/exchange_rates'
    save_and_open_page
    page.select 'GBP', from: 'from_currency'
    page.select 'USD', from: 'to_currency'
    page.fill_in 'date', with: '2017-02-21'
    click_button 'Convert'

    expect(page).to have_text("we don't have rates for those dates")
  end
end
