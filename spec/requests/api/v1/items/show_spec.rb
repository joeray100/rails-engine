require 'rails_helper'

RSpec.describe 'Items Show API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'fetch one item by id' do
      item1 = create(:item)

      get "/api/v1/items/#{item1.id}"
      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      expect(item.count).to eq(1)
      expect(item[:data]).to have_key(:id)
      expect(item[:data]).to have_key(:type)
      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes]).to have_key(:merchant_id)

      expect(item[:data][:id]).to be_a(String)
      expect(item[:data][:type]).to be_a(String)
      expect(item[:data][:attributes]).to be_a(Hash)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  describe 'sad path' do
    it 'bad integer id returns 404' do
      item1 = create(:item)

      get "/api/v1/items/623"
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Item with 'id'=623")
    end
  end

  describe 'edge case' do
    it 'string id returns 404' do
      get '/api/v1/items/string-instead-of-integer'
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Item with 'id'=string-instead-of-integer")
    end
  end
end
