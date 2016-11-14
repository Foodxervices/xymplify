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

    options = { user_id: current_user.id, kitchen_id: @food_item.kitchen_id, supplier_id: @food_item.supplier_id, status: :wip }
    
    order = Order.where(options).first
    
    ActiveRecord::Base.transaction do
      if order.nil?
        order = Order.create(options)
        order.gsts.create(name: 'GST', percent: 7)
      end

      item = order.items.find_or_create_by(food_item_id: @food_item.id)
      item.unit_price = @food_item.unit_price
      item.unit_price_without_promotion = @food_item.unit_price_without_promotion
      
      item.quantity += params[:quantity].to_f
      item.save
    end
  
    order.destroy if order.price_with_gst == 0
  end

  def purchase
    order_ids = []
    ActiveRecord::Base.transaction do
      current_orders.each do |order|
        if order.update(status: :placed)
          order.update_column(:token, SecureRandom.urlsafe_base64)
          order_ids << order.id
        end
      end
    end

    Order.where(id: order_ids).each do |order|
      Premailer::Rails::Hook.perform(OrderMailer.notify_supplier_after_placed(order)).deliver_later
    end

    redirect_to [current_restaurant, :orders], notice: "Your request was submitted successfully."
  end
end