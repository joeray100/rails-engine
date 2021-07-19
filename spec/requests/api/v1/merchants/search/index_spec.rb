require 'rails_helper'

RSpec.describe 'Merchants Search(Find All) Index API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'fetch all merchants matching a pattern' do
      merchant1 = create(:merchant, name: 'Carrot Top')
      merchant2 = create(:merchant, name: 'Joe Rogan')
      merchant3 = create(:merchant, name: 'Mimi Bobeck')

      get '/api/v1/merchants/find_all?name=ro'
      search_result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(search_result.count).to eq(2)
      expect(search_result.first[:attributes][:name]).to eq(merchant1.name)
      expect(search_result.last[:attributes][:name]).to eq(merchant2.name)
    end
  end

  # describe 'sad path' do
  #   it 'no fragment matched' do
  #     get '/api/v1/merchants/find_all?name=ILL'
  #
  #   end
  # end
end
