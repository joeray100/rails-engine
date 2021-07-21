class Api::V1::Revenue::UnshippedController < ApplicationController
  def index
    orders = Invoice.potential_revenue(params.fetch(:quantity, 10))
    render json: UnshippedOrderSerializer.new(orders)
  end
end
