require 'rails_helper'

RSpec.describe 'Items Destroy API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'should be okay to process' do
      merchant1 = create(:merchant)
      item = create(:item, merchant: merchant1)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  # describe 'sad path' do
  #   it '' do
  #     get '/api/v1/items'
  #
  #   end
  # end
end
