class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name]
      items = Item.find_item(params[:name]).first
      render json: ItemSerializer.new(items)
    end
  end
end
