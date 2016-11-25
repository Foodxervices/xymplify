class CartsController < ApplicationController
  load_and_authorize_resource :restaurant

  def show; end 
  
  def new
    @food_items = @restaurant.food_items
                             .where(id: params[:ids])
                             .accessible_by(current_ability)
                             .includes(:kitchens)
    @kitchens = @restaurant.kitchens.accessible_by(current_ability)
  end

  def add
    @food_item = @restaurant.food_items.find(params[:food_item_id])

    authorize! :order, @food_item

    kitchen = @restaurant.kitchens.accessible_by(current_ability).find(params[:kitchen_id])

    options = { user_id: current_user.id, kitchen_id: kitchen.id, supplier_id: @food_item.supplier_id, status: :wip }
    
    @order = Order.where(options).first
    
    ActiveRecord::Base.transaction do
      if @order.nil?
        @order = Order.create(options.merge(outlet_name: kitchen.name, outlet_address: kitchen.address, outlet_phone: kitchen.phone, request_for_delivery_at: 1.days.from_now.beginning_of_day + 10.hours))
        @order.gsts.create(name: 'GST', percent: 7)
      end

      @item = @order.items.find_or_create_by(food_item_id: @food_item.id)
      @item.unit_price = @food_item.unit_price
      @item.unit_price_without_promotion = @food_item.unit_price_without_promotion
      
      @item.quantity += params[:quantity].to_f
      
      @success = @item.save
      
      if !@success
        @message = @item.errors.full_messages.join("<br />")
      end
    end
    
    @order.destroy if @order.reload.price_with_gst == 0
  end

  def confirm
    @order = current_orders.find(params[:id])
  end

  def purchase
    @order = current_orders.find(params[:id])

    ActiveRecord::Base.transaction do
      @success = @order.update_attributes(purchase_params)
    end

    if @success
      @order.update_column(:token, SecureRandom.urlsafe_base64)
      Premailer::Rails::Hook.perform(OrderMailer.notify_supplier_after_placed(@order)).deliver_later
    end
  end

  private 

  def purchase_params
    data = params.require(:order).permit(
        :outlet_name,
        :outlet_address,
        :outlet_phone,
        :request_for_delivery_at,
        :delivered_to_kitchen
      )
    data[:status] = :placed
    data
  end
end