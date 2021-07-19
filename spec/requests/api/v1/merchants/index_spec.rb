require 'rails_helper'

RSpec.describe 'Merchants Index API' do
  before :each do
    FactoryBot.reload
  end

  describe 'happy path' do
    it 'sends a list of no more than 20 merchants' do
      create_list(:merchant, 80)

      get '/api/v1/merchants'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(20)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'fetching page 1 is the same list of first 20 in db' do
      create_list(:merchant, 80)

      get '/api/v1/merchants?page=1'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(20)
      expect(merchants.first[:id]).to eq("1")
      expect(merchants.last[:id]).to eq("20")
    end

    it 'sends the correct amount of merchants based on the per page value' do
      create_list(:merchant, 80)

      get '/api/v1/merchants?per_page=13'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(13)
    end

    it 'sends the correct amount of merchants based on the per page & page value' do
      create_list(:merchant, 80)

      get '/api/v1/merchants?per_page=18&page=1'
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(18)
    end
  end

  describe 'sad path' do
    it 'returns an empty array of merchants when called correctly' do
      get '/api/v1/merchants'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(0)


      expect(merchants).to be_a(Array)
      expect(merchants).to be_empty
    end

    it 'fetching page 1 if page is 0 or lower' do
      create_list(:merchant, 80)

      get '/api/v1/merchants?page=1'
      page1 = JSON.parse(response.body, symbolize_names: true)[:data]

      get '/api/v1/merchants?page=0'
      page0 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(page0.count).to eq(20)
      expect(page1).to eq(page0)
    end
  end
end
