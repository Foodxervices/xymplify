class SupplierOrdersController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :order, :through => :restaurant, parent: false

  def index
    @supplier = Supplier.find(params[:supplier_id])
    @order_filter = OrderFilter.new(@orders, order_filter_params)
    @orders = @order_filter.result
                           .where(status: statuses.collect(&:last))
                           .where(supplier_id: @supplier.id)
  end

  private

  def statuses
    @statuses ||= [["Completed", "completed"], ["Cancelled", "cancelled"], ["Declined", "declined"], ["Placed", "placed"], ["Accepted", "accepted"], ["Delivered", "delivered"]]
  end

  def order_filter_params
    order_filter = ActionController::Parameters.new(params[:order_filter])
    data = order_filter.permit(
      :keyword,
      :date_range,
      :status
    )
    data
  end
end