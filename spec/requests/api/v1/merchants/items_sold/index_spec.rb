require 'rails_helper'

RSpec.describe 'Items Sold Index Page API' do
  before :each do
    FactoryBot.reload
    merchants = create_list(:merchant, 9)
    item1 = create(:item, merchant: merchants[0])
    item2 = create(:item, merchant: merchants[1])
    item3 = create(:item, merchant: merchants[2])
    item4 = create(:item, merchant: merchants[3])
    item5 = create(:item, merchant: merchants[4])
    item6 = create(:item, merchant: merchants[5])
    item7 = create(:item, merchant: merchants[6])
    item8 = create(:item, merchant: merchants[7])
    item9 = create(:item, merchant: merchants[8])
    invoice1 = create(:invoice, merchant: merchants[0], status: 'shipped')
    invoice2 = create(:invoice, merchant: merchants[1], status: 'shipped')
    invoice3 = create(:invoice, merchant: merchants[2], status: 'shipped')
    invoice4 = create(:invoice, merchant: merchants[3], status: 'shipped')
    invoice5 = create(:invoice, merchant: merchants[4], status: 'shipped')
    invoice6 = create(:invoice, merchant: merchants[5], status: 'shipped')
    invoice7 = create(:invoice, merchant: merchants[6], status: 'shipped')
    invoice8 = create(:invoice, merchant: merchants[7], status: 'shipped')
    invoice9 = create(:invoice, merchant: merchants[8], status: 'shipped')
    invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 6)
    invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 8)
    invoice_item3 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 10)
    invoice_item4 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 3)
    invoice_item5 = create(:invoice_item, item: item5, invoice: invoice5, quantity: 32)
    invoice_item6 = create(:invoice_item, item: item6, invoice: invoice6, quantity: 15)
    invoice_item7 = create(:invoice_item, item: item7, invoice: invoice7, quantity: 2)
    invoice_item8 = create(:invoice_item, item: item8, invoice: invoice8, quantity: 4)
    invoice_item9 = create(:invoice_item, item: item9, invoice: invoice9, quantity: 12)
    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')
    transaction4 = create(:transaction, invoice: invoice4, result: 'success')
    transaction5 = create(:transaction, invoice: invoice5, result: 'success')
    transaction6 = create(:transaction, invoice: invoice6, result: 'success')
    transaction7 = create(:transaction, invoice: invoice7, result: 'success')
    transaction8 = create(:transaction, invoice: invoice8, result: 'success')
    transaction8 = create(:transaction, invoice: invoice9, result: 'success')
  end

  describe 'happy path' do
    it 'fetch top 8 merchants by items sold' do
      get '/api/v1/merchants/most_items?quantity=8'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(8)
      merchants.each do |merchant|

        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes]).to have_key(:count)

        expect(merchant[:id]).to be_a(String)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes][:name]).to be_a(String)
        expect(merchant[:attributes][:count]).to be_an(Integer)
      end
    end

    it 'top one merchant by items sold' do
      get '/api/v1/merchants/most_items?quantity=1'
      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant.count).to eq(1)
      expect(merchant.first[:attributes][:count]).to eq(32)
    end

    it 'all 100 merchants if quantity is too big' do
      get '/api/v1/merchants/most_items?quantity=100'
      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant.count).to eq(9)
      expect(merchant.last[:attributes][:count]).to eq(2)
    end
  end

  # describe 'sad path' do
  #   it 'returns an error of some sort if quantity value is blank' do
  #     get '/api/v1/merchants/most_items?quantity= '
  #     expect(response).to be_successful
  #     error = JSON.parse(response.body, symbolize_names: true)[:data]
  #
  #     expect(error).to eq(0)
  #   end
  #
  #   it 'returns an error of some sort if quantity is a string' do
  #     get '/api/v1/merchants/most_items?quantity=x'
  #   end
  #
  #   it 'quantity param is missing' do
  #     get '/api/v1/merchants/most_items?quantity=x'
  #   end
  # end
end
