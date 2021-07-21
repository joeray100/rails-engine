require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  before :each do
    @merchant1 = create(:merchant)
    item = create_list(:item, 3, merchant: @merchant1)
    invoice = create_list(:invoice, 3, merchant: @merchant1, status: 'shipped')
    @invoice_item1 = create(:invoice_item, item: item[0], invoice: invoice[0], quantity: 5, unit_price: 15.50)
    @invoice_item2 = create(:invoice_item, item: item[1], invoice: invoice[1], quantity: 1, unit_price: 100.00)
    @invoice_item3 = create(:invoice_item, item: item[2], invoice: invoice[2], quantity: 2, unit_price: 25.00)
    @transaction1 = create(:transaction, invoice: invoice[0], result: 'success')
    @transaction2 = create(:transaction, invoice: invoice[1], result: 'success')
    @transaction3 = create(:transaction, invoice: invoice[2], result: 'success')
  end

  # describe 'class methods' do
  #   describe '.' do
  #   end
  # end

  describe 'instance methods' do
    describe '#revenue' do
      it 'returns the total revenue for a single merchant' do
        expect(@merchant1.revenue).to eq(227.5)
      end
    end
  end
end
