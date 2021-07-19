require 'rails_helper'

RSpec.describe 'Items Index API' do
  before :each do
    FactoryBot.reload
    @merchants = create_list(:merchant, 25)
    @items = create_list(:item, 50)
  end

  describe 'happy path' do
    it 'fetch all items if per page is really big' do
      get '/api/v1/items?per_page=250000'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(50)
    end

    it 'fetch all items, a maximum of 20 at a time' do
      get '/api/v1/items'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(20)

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item).to have_key(:type)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)

        expect(item[:id]).to be_a(String)
        expect(item[:type]).to be_a(String)
        expect(item[:attributes]).to be_a(Hash)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'fetching page 1 is the same list of first 20 in db' do
      get '/api/v1/items?page=1'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(20)
      expect(items.first[:id]).to eq("1")
      expect(items.last[:id]).to eq("20")
    end

    it 'fetch first page of 50 items' do
      get '/api/v1/items?per_page=50&page=1'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(50)
      expect(items.first[:id]).to eq("1")
      expect(items.last[:id]).to eq("50")
    end

    it 'fetch second page of 20 items' do
      get '/api/v1/items?page=2'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(20)
      expect(items.first[:id]).to eq("21")
      expect(items.last[:id]).to eq("40")
    end

    it 'fetch a page of items which would contain no data' do
      get '/api/v1/items?page=5'
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(0)
      expect(items).to be_empty
    end
  end

  describe 'sad path' do
    it 'fetching page 1 if page is 0 or lower' do
      get '/api/v1/items?page=1'
      page1 = JSON.parse(response.body, symbolize_names: true)[:data]

      get '/api/v1/items?page=0'
      page2 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(page2.count).to eq(20)
      expect(page1).to eq(page2)
    end
  end
end
