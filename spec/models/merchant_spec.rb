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
    FactoryBot.reload
  end

  describe 'class methods' do
    describe '.most_items_sold' do
      it 'should return a variable number of merchants ranked by total number of items sold' do
        merchants = create_list(:merchant, 5)
        item1 = create(:item, merchant: merchants[0])
        item2 = create(:item, merchant: merchants[1])
        item3 = create(:item, merchant: merchants[2])
        item4 = create(:item, merchant: merchants[3])
        item5 = create(:item, merchant: merchants[4])
        invoice1 = create(:invoice, merchant: merchants[0], status: 'shipped')
        invoice2 = create(:invoice, merchant: merchants[1], status: 'shipped')
        invoice3 = create(:invoice, merchant: merchants[2], status: 'shipped')
        invoice4 = create(:invoice, merchant: merchants[3], status: 'shipped')
        invoice5 = create(:invoice, merchant: merchants[4], status: 'shipped')
        invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 6)
        invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 8)
        invoice_item3 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 10)
        invoice_item4 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 3)
        invoice_item5 = create(:invoice_item, item: item5, invoice: invoice5, quantity: 1)
        transaction1 = create(:transaction, invoice: invoice1, result: 'success')
        transaction2 = create(:transaction, invoice: invoice2, result: 'success')
        transaction3 = create(:transaction, invoice: invoice3, result: 'success')
        transaction4 = create(:transaction, invoice: invoice4, result: 'success')
        transaction5 = create(:transaction, invoice: invoice5, result: 'success')

        expect(Merchant.most_items_sold(3)).to eq([merchants[2], merchants[1], merchants[0]])
        expect(Merchant.most_items_sold(2)).to eq([merchants[2], merchants[1]])
      end
    end

    describe '.by_revenue' do
      it 'should return a variable number of merchants ranked by total revenue' do
        merchants = create_list(:merchant, 5)
        item1 = create(:item, merchant: merchants[0])
        item2 = create(:item, merchant: merchants[1])
        item3 = create(:item, merchant: merchants[2])
        item4 = create(:item, merchant: merchants[3])
        item5 = create(:item, merchant: merchants[4])
        invoice1 = create(:invoice, merchant: merchants[0], status: 'shipped')
        invoice2 = create(:invoice, merchant: merchants[1], status: 'shipped')
        invoice3 = create(:invoice, merchant: merchants[2], status: 'shipped')
        invoice4 = create(:invoice, merchant: merchants[3], status: 'shipped')
        invoice5 = create(:invoice, merchant: merchants[4], status: 'shipped')
        invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 6, unit_price: 15.50)
        invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 8, unit_price: 35.50)
        invoice_item3 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 10, unit_price: 9.00)
        invoice_item4 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 3, unit_price: 75.00)
        invoice_item5 = create(:invoice_item, item: item5, invoice: invoice5, quantity: 8, unit_price: 48.25)
        transaction1 = create(:transaction, invoice: invoice1, result: 'success')
        transaction2 = create(:transaction, invoice: invoice2, result: 'success')
        transaction3 = create(:transaction, invoice: invoice3, result: 'success')
        transaction4 = create(:transaction, invoice: invoice4, result: 'success')
        transaction5 = create(:transaction, invoice: invoice5, result: 'success')

        expect(Merchant.by_revenue(3)).to eq([merchants[4], merchants[1], merchants[3]])
        expect(Merchant.by_revenue(1)).to eq([merchants[4]])
      end
    end
  end

  describe 'instance methods' do
    describe '#revenue' do
      it 'returns the total revenue for a single merchant' do
        merchant1 = create(:merchant)
        item = create_list(:item, 3, merchant: merchant1)
        invoice = create_list(:invoice, 3, merchant: merchant1, status: 'shipped')
        invoice_item1 = create(:invoice_item, item: item[0], invoice: invoice[0], quantity: 5, unit_price: 15.50)
        invoice_item2 = create(:invoice_item, item: item[1], invoice: invoice[1], quantity: 1, unit_price: 100.00)
        invoice_item3 = create(:invoice_item, item: item[2], invoice: invoice[2], quantity: 2, unit_price: 25.00)
        transaction1 = create(:transaction, invoice: invoice[0], result: 'success')
        transaction2 = create(:transaction, invoice: invoice[1], result: 'success')
        transaction3 = create(:transaction, invoice: invoice[2], result: 'success')

        expect(merchant1.revenue).to eq(227.5)
      end
    end
  end
end
