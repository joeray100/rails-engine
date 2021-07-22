class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def revenue
    invoice_items
    .joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  class << self
    def most_items_sold(quantity)
      joins(invoice_items: :transactions).
      where(transactions: {result: 'success'}, invoices: {status: 'shipped'}).
      group(:id).
      select('merchants.*, sum(invoice_items.quantity) as count').
      order('count desc').
      limit(quantity)
    end

    def by_revenue(quantity)
      joins(invoice_items: :transactions).
      where(transactions: {result: 'success'}, invoices: {status: 'shipped'}).
      group(:id).
      select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').
      order('revenue desc').
      limit(quantity)
    end
  end
end
