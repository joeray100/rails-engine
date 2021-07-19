require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'fetch all items' do
      merchant = create(:merchant)
      create_list(:item, 5, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]

      items.each do |item|

        expect(item).to have_key(:id)
        expect(item).to have_key(:type)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)

        expect(item[:id]).to be_a(String)
        expect(item[:type]).to be_a(String)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end

  describe 'sad path' do
    it 'bad integer id returns 404' do
      merchant = create(:merchant)
      create_list(:item, 5, merchant: merchant)

      get "/api/v1/merchants/2/items"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Merchant with 'id'=2")
    end
  end
end
