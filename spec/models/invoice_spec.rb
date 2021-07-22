require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_id) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:status) }
  end

  before :each do
    @merchant1 = create(:merchant)
    item = create_list(:item, 3, merchant: @merchant1)

    @invoice1 = create(:invoice, merchant: @merchant1, status: 'packaged')
    @invoice2 = create(:invoice, merchant: @merchant1, status: 'packaged')
    @invoice3 = create(:invoice, merchant: @merchant1, status: 'packaged')

    @invoice_item1 = create(:invoice_item, item: item[0], invoice: @invoice1, quantity: 5, unit_price: 15.50) # 77.50
    @invoice_item2 = create(:invoice_item, item: item[1], invoice: @invoice2, quantity: 1, unit_price: 100.00) # 100.00
    @invoice_item3 = create(:invoice_item, item: item[2], invoice: @invoice3, quantity: 2, unit_price: 25.00) # 50.00

    @transaction1 = create(:transaction, invoice: @invoice1, result: 'success')
    @transaction2 = create(:transaction, invoice: @invoice2, result: 'success')
    @transaction3 = create(:transaction, invoice: @invoice3, result: 'success')
  end

  describe 'class methods' do
    describe '.potential_revenue' do
      it 'returns total revenue of successful invoices which have not yet been shipped' do

        expect(Invoice.potential_revenue(2)).to eq([@invoice2, @invoice1])
        expect(Invoice.potential_revenue(3)).to eq([@invoice2, @invoice1, @invoice3])
        expect(Invoice.potential_revenue(3)).to_not eq([@invoice1, @invoice2])
      end
    end
  end

  # describe 'instance methods' do
  #   describe '#' do
  #   end
  # end
end
