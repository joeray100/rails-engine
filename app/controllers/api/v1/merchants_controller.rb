class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all.limit(per_page).offset(page)
    render json: MerchantSerializer.new(merchants)
  end

  private

  def per_page
    if params[:per_page].to_i == 0
      20
    else
      params[:per_page].to_i
    end
  end

  def page
    if params[:per_page].to_i == 0
      1
     else
       params[:page].to_i
     end
  end
end
