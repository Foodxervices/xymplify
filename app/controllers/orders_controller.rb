class OrdersController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :order, :through => :restaurant, :shallow => true

  def index
    @orders = @orders.includes(:supplier).where.not(status: :wip)
  end

  def show; end 
  
  def edit; end

  def update
    @success = @order.update_attributes(order_params)

    if @success
      @order.destroy if @order.items.empty?
    end
  end

  def destroy
    if @order.destroy
      flash[:notice] = "#{@order.name} has been deleted."
    else
      flash[:notice] = @order.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  private

  def order_params
    params.require(:order).permit(
      items_attributes: [
        :id,
        :quantity,
        :_destroy
      ]
    )
  end
end