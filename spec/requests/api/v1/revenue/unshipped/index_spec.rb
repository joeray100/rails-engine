require 'rails_helper'

RSpec.describe 'Unshipped Index Page API' do
  before :each do
    FactoryBot.reload
    @merchant1 = create(:merchant)
    item = create_list(:item, 11, merchant: @merchant1)
    invoice = create_list(:invoice, 11, merchant: @merchant1, status: 'packaged')

    @invoice_item1 = create(:invoice_item, item: item[0], invoice: invoice[0], quantity: 5, unit_price: 15.50) # 77.50
    @invoice_item2 = create(:invoice_item, item: item[1], invoice: invoice[1], quantity: 1, unit_price: 100.00) # 100.00
    @invoice_item3 = create(:invoice_item, item: item[2], invoice: invoice[2], quantity: 2, unit_price: 30.00) # 50.00
    @invoice_item4 = create(:invoice_item, item: item[3], invoice: invoice[3], quantity: 3, unit_price: 45.00) # 135.00
    @invoice_item5 = create(:invoice_item, item: item[4], invoice: invoice[4], quantity: 6, unit_price: 10.00) # 60.00
    @invoice_item6 = create(:invoice_item, item: item[5], invoice: invoice[5], quantity: 10, unit_price: 5.00) # 50.00
    @invoice_item7 = create(:invoice_item, item: item[6], invoice: invoice[6], quantity: 2, unit_price: 32.00) # 64.00
    @invoice_item8 = create(:invoice_item, item: item[7], invoice: invoice[7], quantity: 4, unit_price: 47.00) # 188.00
    @invoice_item9 = create(:invoice_item, item: item[8], invoice: invoice[8], quantity: 4, unit_price: 35.00) # 140.00
    @invoice_item10 = create(:invoice_item, item: item[9], invoice: invoice[9], quantity: 10, unit_price: 5.00) # 50.00
    @invoice_item11 = create(:invoice_item, item: item[10], invoice: invoice[10], quantity: 20, unit_price: 10.00) # 200.00

    @transaction1 = create(:transaction, invoice: invoice[0], result: 'success')
    @transaction2 = create(:transaction, invoice: invoice[1], result: 'success')
    @transaction3 = create(:transaction, invoice: invoice[2], result: 'success')
    @transaction4 = create(:transaction, invoice: invoice[3], result: 'success')
    @transaction5 = create(:transaction, invoice: invoice[4], result: 'success')
    @transaction6 = create(:transaction, invoice: invoice[5], result: 'success')
    @transaction7 = create(:transaction, invoice: invoice[6], result: 'success')
    @transaction8 = create(:transaction, invoice: invoice[7], result: 'success')
    @transaction9 = create(:transaction, invoice: invoice[8], result: 'success')
    @transaction10 = create(:transaction, invoice: invoice[9], result: 'success')
    @transaction11 = create(:transaction, invoice: invoice[10], result: 'success')
  end

  describe 'happy path' do
    it 'fetch top invoices which are not shipped' do
      get "/api/v1/revenue/unshipped"
      expect(response).to be_successful
      unshipped_orders = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(unshipped_orders.count).to eq(10)
      expect(unshipped_orders.count).to_not eq(11)

      unshipped_orders.each do |order|
        expect(order).to have_key(:id)
        expect(order).to have_key(:type)
        expect(order).to have_key(:attributes)
        expect(order[:attributes]).to have_key(:potential_revenue)

        expect(order[:id]).to be_a(String)
        expect(order[:type]).to be_a(String)
        expect(order[:attributes]).to be_a(Hash)
        expect(order[:attributes][:potential_revenue]).to be_a(Float)
      end
    end

    it 'top one invoice by potential revenue' do
      get "/api/v1/revenue/unshipped?quantity=1"
      expect(response).to be_successful
      top_unshipped_order = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(top_unshipped_order.count).to eq(1)
      expect(top_unshipped_order.count).to_not eq(2)
      expect(top_unshipped_order.first[:attributes][:potential_revenue]).to eq(200.0)
    end

    it 'all invoices if quantity is too big' do
      get "/api/v1/revenue/unshipped?quantity=9999"
      expect(response).to be_successful
      all_unshipped_orders = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(all_unshipped_orders.count).to eq(11)
      expect(all_unshipped_orders.count).to_not eq(10)
    end
  end

  # describe 'sad path' do
  #   it 'returns an error of some sort if quantity is a string' do
  #     get '/api/v1/revenue/unshipped?quantity=#asdasd'
  #     expect(response).to_not be_successful
  #     expect(response).to have_http_status(404)
  #     error = JSON.parse(response.body, symbolize_names: true)[:error]
  #     expect(error).to eq()
  #   end
  #
  #   it 'returns an error of some sort if quantity value is blank' do
  #     get "/api/v1/revenue/unshipped?quantity="
  #     expect(response).to_not be_successful
  #     expect(response).to have_http_status(404)
  #     error = JSON.parse(response.body, symbolize_names: true)[:error]
  #     expect(error).to eq()
  #   end
  # end
end
