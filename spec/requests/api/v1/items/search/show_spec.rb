require 'rails_helper'

RSpec.describe 'Merchants Search(Find All) Show API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'fetch one item by fragment' do
      item1 = create(:item, name: 'desk')
      item2 = create(:item, name: 'yo-yo')

      get '/api/v1/items/find?name=es'
      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(search_result.count).to eq(1)
      expect(search_result[:data][:attributes][:name]).to eq(item1.name)
      expect(search_result[:data][:attributes][:name]).to_not eq(item2.name)
    end

    it 'fetch one item by min_price' do
      item1 = create(:item, unit_price: 3.00)
      item2 = create(:item, unit_price: 6.00)

      get '/api/v1/items/find?min_price=5'
      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(search_result.count).to eq(1)
      expect(search_result[:data][:attributes][:unit_price]).to eq(6.0)
      expect(search_result[:data][:attributes][:unit_price]).to_not eq(3.0)
    end

    it 'fetch one item by max price' do
      item1 = create(:item, unit_price: 13.00)
      item2 = create(:item, unit_price: 25.00)

      get '/api/v1/items/find?max_price=20'
      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(search_result.count).to eq(1)
      expect(search_result[:data][:attributes][:unit_price]).to eq(13.0)
      expect(search_result[:data][:attributes][:unit_price]).to_not eq(20.0)
    end

    it 'max_price is so small that nothing matches' do
      item1 = create(:item, unit_price: 13.00)
      item2 = create(:item, unit_price: 25.00)

      get '/api/v1/items/find?max_price=10'
      search_result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(search_result).to eq(nil)
    end

    # it 'min_price is so big that nothing matches' do
    #   item1 = create(:item, name: 'desk')
    #   item2 = create(:item, name: 'yo-yo')
    #
    #   get '/api/v1/items/find?name=es'
    #   search_result = JSON.parse(response.body, symbolize_names: true)
    #
    #   expect(response).to be_successful
    #   expect(search_result.count).to eq(1)
    #   expect(search_result[:data][:attributes][:name]).to eq(item1.name)
    #   expect(search_result[:data][:attributes][:name]).to_not eq(item2.name)
    # end
  end

  # describe 'sad path' do
  #   it 'no fragment matched' do
  #     get '/api/v1/items/find?name=es'
  #
  #   end
  #
  #   it 'cannot send name and min_price' do
  #     get '/api/v1/items/find?name=es'
  #
  #   end
  #
  #   it 'max_price less than 0' do
  #     get '/api/v1/items/find?name=es'
  #
  #   end
  #
  #   it 'min_price less than 0' do
  #     get '/api/v1/items/find?name=es'
  #
  #   end
  #
  #   it 'cannot send name and max_price' do
  #     get '/api/v1/items/find?name=es'
  #
  #   end
  # end
end
