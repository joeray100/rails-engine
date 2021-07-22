class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    merchants = Merchant.by_revenue(params[:quantity] || 5)
    render json: MerchantNameRevenueSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
