class Api::V1::Merchants::SearchController < ApplicationController
  def index
    if params[:name]
      merchants = Merchant.find_all_merchants(params[:name])
      render json: MerchantSerializer.new(merchants)
    end
  end
end
