class KitchensController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :through => :restaurant, :shallow => true

  def index; end 

  def show; end

  def dashboard
    alerts = Alert.accessible_by(current_ability, kitchen: current_kitchen)
                                .includes(:alertable)
                                .order(id: :desc)

    @alerts              = alerts.where.not(type: :incoming_delivery).paginate(:page => params[:alert_page], :per_page => 5)
    @incoming_deliveries = alerts.where(type: :incoming_delivery).paginate(:page => params[:incoming_delivery_page], :per_page => 5)

    @messages = Message.accessible_by(current_ability)
    
    @messages = @messages.where("(kitchen_id IS NULL AND restaurant_id = ?) OR kitchen_id = ?", current_restaurant.id, current_kitchen.id)
    @messages = @messages.order(id: :desc).paginate(:page => params[:message_page], :per_page => 5)

    @notification = Notification.new(current_ability, current_kitchen, current_user)
    
    @graph_data = CostGraph.new(current_restaurant, kitchen: current_kitchen).result
    @currency_symbol = Money::Currency.new(current_restaurant.currency).symbol
    @display_more_activity_link = true
    load_summary
  end

  private 
  def load_summary
    total_suppliers   = Supplier.where(restaurant_id: current_restaurant.id).count
    total_food_items  = FoodItem.joins(:kitchens).where(kitchens: { id: current_kitchen.id }).count
    pending_orders = Order.where(kitchen_id: current_kitchen.id).where(status: [:placed, :accepted])
    shipped_orders = Order.where(kitchen_id: current_kitchen.id).where(status: [:delivered])

    @summary = [
      { type: 'suppliers',   count: total_suppliers, description: "Suppliers" },
      { type: 'food_items',  count: total_food_items,  description: "Food Items" },
      { type: 'pending_pos', count: "#{pending_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(pending_orders.price)} PENDING" },
      { type: 'shipped_pos', count: "#{shipped_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(shipped_orders.price)} SHIPPED" }
    ]
  end
end