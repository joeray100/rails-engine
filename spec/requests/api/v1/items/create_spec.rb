require 'rails_helper'

RSpec.describe 'Items Create API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'should be okay to process' do
      merchant = create(:merchant)
      item_params = {
        name: 'jacket',
        description: 'Good for fall and winter!',
        unit_price: 30.00,
        merchant_id: merchant.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  # describe 'sad path' do
  #   it '' do
  #     get '/api/v1/items'
  #
  #   end
  # end
end
