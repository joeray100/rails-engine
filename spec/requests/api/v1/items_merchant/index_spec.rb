require 'rails_helper'

RSpec.describe 'Items Merchant API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'fetch one merchant by id' do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)

      get "/api/v1/items/#{item1.id}/merchant"
      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant[:id].to_i).to eq(merchant1.id)
      expect(merchant[:attributes][:name]).to eq(merchant1.name)
    end
  end

  describe 'sad path' do
    it 'bad integer id returns 404' do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)

      get "/api/v1/items/3/merchant"
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Item with 'id'=3")
    end
  end
  
  describe 'edge case' do
    it 'string id returns 404' do
      get "/api/v1/items/string-instead-of-integer/merchant"
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Item with 'id'=string-instead-of-integer")
    end
  end
end
