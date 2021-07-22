class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    merchants = Merchant.most_items_sold(params[:quantity] || 5)
    render json: ItemsSoldSerializer.new(merchants)
  end
end
