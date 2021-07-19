require 'rails_helper'

RSpec.describe 'Items Update API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'can update an existing item' do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: 'sweater' }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq('sweater')
    end

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

    it 'works with only partial data, too' do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: 'sweater' }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq('sweater')
    end
  end

  # describe 'sad path' do
  #   it 'bad integer id returns 404' do
  #
  #   end
  # end

  # describe 'edge case' do
  #   it 'bad merchant id returns 400 or 404' do
  #     merchant1 = create(:merchant)
  #     id = create(:item, merchant: merchant1).id
  #     previous_name = Item.last.name
  #     item_params = { merchant_id: 999999999999 }
  #     headers = {"CONTENT_TYPE" => "application/json"}
  #     item = Item.find_by(id: id)
  #
  #     patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
  #
  #     expect(response.status).to have_http_status(400)
  #   end

  #   it 'string id returns 404' do
  #
  #   end
  # end
end
