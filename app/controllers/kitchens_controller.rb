class KitchensController < ApplicationController
  before_action :disable_bullet, only: [:dashboard]
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :through => :restaurant, :shallow => true

  def index; end

  def show; end

  def new; end

  def create
    if @kitchen.save
      redirect_to :back, notice: 'Kitchen has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @kitchen.update_attributes(kitchen_params)
      redirect_to :back, notice: 'Kitchen has been updated.'
    else
      render :edit
    end
  end

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

    @display_more_activity_link = true
    load_summary
  end

  private

  def kitchen_params
    data = params.require(:kitchen).permit(
      :id,
      :name,
      :address,
      :phone,
      :bank_name,
      :bank_address,
      :bank_swift_code,
      :bank_account_name,
      :bank_account_number,
      supplier_ids: []
    )
    data[:restaurant_id] = current_restaurant.id
    data
  end

  def load_summary
    total_suppliers   = Supplier.where(restaurant_id: current_restaurant.id).count
    total_food_items  = FoodItem.joins(:kitchens).where(kitchens: { id: current_kitchen.id }).count
    orders         = Order.where(kitchen_id: current_kitchen.id)
    pending_orders = orders.where(status: [:placed, :accepted])
    shipped_orders = orders.where(status: :delivered)

    @summary = [
      { type: 'suppliers',   count: total_suppliers, description: "Suppliers" },
      { type: 'food_items',  count: total_food_items,  description: "Food Items" },
      { type: 'shipped_pos', count: "#{shipped_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(shipped_orders.price)} DELIVERED" },
      { type: 'pending_pos', count: "#{pending_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(pending_orders.price)} PENDING" }
    ]
  end
end