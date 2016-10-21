class CartsController < ApplicationController
  load_and_authorize_resource :restaurant

  def show; end 
  
  def new
    @food_items = @restaurant.food_items
                             .accessible_by(current_ability)
                             .where(id: params[:ids])
  end

  def add
    @food_item = @restaurant.food_items.find(params[:food_item_id])

    authorize! :order, @food_item

    order = Order.find_or_create_by(user_id: current_user.id, kitchen_id: @food_item.kitchen_id, supplier_id: @food_item.supplier_id, status: :wip)
    item = order.items.find_or_create_by(food_item_id: @food_item.id)
    item.unit_price = @food_item.unit_price
    item.quantity += params[:quantity].to_f
    item.save
  
    order.destroy if order.price_with_gst == 0
  end

  def purchase
    ActiveRecord::Base.transaction do
      current_orders.each do |order|
        order.update(status: :placed)
      end
    end

    redirect_to [current_restaurant, :orders], notice: "Your request was submitted successfully."
  end
end