class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice

  validates_presence_of :item_id, :invoice_id, :quantity, :unit_price
end
