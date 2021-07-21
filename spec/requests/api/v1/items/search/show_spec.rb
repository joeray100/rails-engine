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
  end

  # describe 'sad path' do
  #   it 'no fragment matched' do
  #     get '/api/v1/items/find?name=es'
  #
  #   end
  # end
end
