require 'rails_helper'

RSpec.describe 'Revenue Index Page API' do
  before :each do
    FactoryBot.reload
    merchants = create_list(:merchant, 5)
    item1 = create(:item, merchant: merchants[0])
    item2 = create(:item, merchant: merchants[1])
    item3 = create(:item, merchant: merchants[2])
    item4 = create(:item, merchant: merchants[3])
    item5 = create(:item, merchant: merchants[4])
    invoice1 = create(:invoice, merchant: merchants[0], status: 'shipped')
    invoice2 = create(:invoice, merchant: merchants[1], status: 'shipped')
    invoice3 = create(:invoice, merchant: merchants[2], status: 'shipped')
    invoice4 = create(:invoice, merchant: merchants[3], status: 'shipped')
    invoice5 = create(:invoice, merchant: merchants[4], status: 'shipped')
    invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 6, unit_price: 15.50)
    invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 8, unit_price: 35.50)
    invoice_item3 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 10, unit_price: 9.00)
    invoice_item4 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 3, unit_price: 75.00)
    invoice_item5 = create(:invoice_item, item: item5, invoice: invoice5, quantity: 8, unit_price: 48.25)
    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')
    transaction4 = create(:transaction, invoice: invoice4, result: 'success')
    transaction5 = create(:transaction, invoice: invoice5, result: 'success')
  end

  describe 'happy path' do
    it 'fetch top 5 merchants by revenue' do
      get '/api/v1/revenue/merchants?quantity=5'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(5)

      merchants.each do |merchant|

        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes]).to have_key(:revenue)

        expect(merchant[:id]).to be_a(String)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes][:name]).to be_a(String)
        expect(merchant[:attributes][:revenue]).to be_a(Float)
      end
    end

    it 'top one merchant by revenue' do
      get '/api/v1/revenue/merchants?quantity=1'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(1)
    end

    it 'all 100 merchants if quantity is too big' do
      get '/api/v1/revenue/merchants?quantity=100'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(5)
    end
  end

  # describe 'sad path' do
  #   it 'returns an error of some sort if quantity value is blank' do
  #     get '/api/v1/'
  #
  #   end
  #
  #   it 'returns an error of some sort if quantity is a string' do
  #     get '/api/v1/'
  #
  #   end
  #
  #   it 'quantity param is missing' do
  #     get '/api/v1/'
  #
  #   end
  # end
end
