class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items

  validates_presence_of :customer_id, :merchant_id, :status

  class << self
    def potential_revenue(quantity)
      joins(:invoice_items, :transactions)
      .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
      .group(:id)
      .where('result = ? AND status = ?', 'success', 'packaged')
      .order('potential_revenue DESC')
      .limit(quantity)
    end
  end
end
