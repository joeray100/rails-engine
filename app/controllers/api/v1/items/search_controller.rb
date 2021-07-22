class Api::V1::Items::SearchController < ApplicationController
  def show
    item = if params[:name]
      Item.find_item(params[:name])
    elsif params[:min_price]
      Item.min_price(params[:min_price])
    elsif params[:max_price]
      Item.max_price(params[:max_price])
    elsif params[:min_price] && params[:max_price]
      Item.min_and_max_price(params[:min_price], params[:max_price])
    end
    render json: ItemSerializer.new(item)
  end
end
