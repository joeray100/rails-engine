class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates_presence_of :name, :description, :unit_price, :merchant_id

  class << self
    def min_price(price)
      where('unit_price >= ?', "#{price}").
      order(:name).
      first
    end

    def max_price(price)
      where('unit_price <= ?', "#{price}").
      order(:name).
      first
    end

    def min_and_max_price(min, max)
      where('unit_price between ? and ?', "#{min}", "#{max}").
      order(:name).
      first
    end
  end
end
