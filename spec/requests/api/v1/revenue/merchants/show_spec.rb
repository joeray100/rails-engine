require 'rails_helper'

RSpec.describe 'Revenue Show Page API' do
  before :each do
    FactoryBot.reload
    @merchant1 = create(:merchant)
    item = create_list(:item, 3, merchant: @merchant1)
    invoice = create_list(:invoice, 3, merchant: @merchant1, status: 'shipped')
    invoice_item1 = create(:invoice_item, item: item[0], invoice: invoice[0], quantity: 5, unit_price: 15.50)
    invoice_item2 = create(:invoice_item, item: item[1], invoice: invoice[1], quantity: 1, unit_price: 100.00)
    invoice_item3 = create(:invoice_item, item: item[2], invoice: invoice[2], quantity: 2, unit_price: 25.00)
    transaction1 = create(:transaction, invoice: invoice[0], result: 'success')
    transaction2 = create(:transaction, invoice: invoice[1], result: 'success')
    transaction3 = create(:transaction, invoice: invoice[2], result: 'success')
  end

  describe 'happy path' do
    it 'fetch revenue for merchant id' do
      get "/api/v1/revenue/merchants/#{@merchant1.id}"
      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:type)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:revenue)

      expect(merchant[:id]).to be_a(String)
      expect(merchant[:type]).to be_a(String)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes][:revenue]).to be_a(Float)
      expect(merchant[:attributes][:revenue]).to eq(227.5)
    end
  end

  describe 'sad path' do
    it 'bad integer id returns 404' do
      get "/api/v1/revenue/merchants/3"
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Merchant with 'id'=3")
    end
  end
end
