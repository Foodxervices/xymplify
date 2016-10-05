class OrdersController < ApplicationController
  load_and_authorize_resource

  def edit; end

  def update
    @success = @order.update_attributes(order_params)
    @restaurant = @order.restaurant if @success
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
    return {} if params[:order].nil?

    params.require(:order).permit(
      items_attributes: [
        :id,
        :quantity,
        :_destroy
      ]
    )
  end
end