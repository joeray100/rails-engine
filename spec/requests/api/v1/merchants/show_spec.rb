require 'rails_helper'

RSpec.describe 'Merchants Show API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'fetch one merchant by id' do
      merchant1 = create(:merchant)

      get "/api/v1/merchants/#{merchant1.id}"
      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(merchant.count).to eq(1)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)

      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_a(String)

      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe 'sad path' do
    it 'bad integer id returns 404' do

      get "/api/v1/merchants/623"
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Merchant with 'id'=623")
    end
  end
end
