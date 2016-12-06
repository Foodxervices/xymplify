class RestaurantsController < ApplicationController
  before_action :disable_bullet, only: [:show, :index, :dashboard]
  load_and_authorize_resource 

  def index
    respond_to do |format|
      format.html do
        @restaurant_filter = RestaurantFilter.new(restaurant_filter_params)
        @restaurants  = @restaurant_filter.result
                                          .accessible_by(current_ability)
        if @restaurants.size == 1 && !params[:restaurant_filter]                                                                                   
          redirect_to [:dashboard, @restaurants.first]     
        else
          load_summary(@restaurants.ids)
        end
      end

      format.js  do
        @restaurants  = Restaurant.accessible_by(current_ability)
      end
    end
  end

  def show; end

  def new; end

  def create
    if @restaurant.save
      redirect_to restaurants_url, notice: 'Restaurant has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @restaurant.update_attributes(restaurant_params)
      redirect_to restaurants_url, notice: 'Restaurant has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @restaurant.destroy
      flash[:notice] = 'Restaurant has been deleted.'
    else
      flash[:notice] = @restaurant.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  def dashboard
    alerts = Alert.accessible_by(current_ability, restaurant: @restaurant)
                                .includes(:alertable)
                                .paginate(:page => params[:alert_page], :per_page => 5)
                                .order(id: :desc)

    @alerts              = alerts.where.not(type: :incoming_delivery)          
    @incoming_deliveries = alerts.where(type: :incoming_delivery)

    @messages = @restaurant.messages.accessible_by(current_ability).order(id: :desc).paginate(:page => params[:message_page], :per_page => 5)

    @notification = Notification.new(current_ability, current_restaurant, current_user)
    
    @graph_data = CostGraph.new(@restaurant).result
    @currency_symbol = Money::Currency.new(@restaurant.currency).symbol
    @display_more_activity_link = true
    load_summary([@restaurant.id])
  end

  private 

  def restaurant_filter_params
    restaurant_filter = ActionController::Parameters.new(params[:restaurant_filter])
    restaurant_filter.permit(
      :keyword,
    )
  end

  def restaurant_params
    params.require(:restaurant).permit(
      :name,
      :site_address,
      :billing_address,
      :contact_person,
      :telephone,
      :email,
      :currency,
      :company_registration_no,
      :logo,
      kitchens_attributes: [
                    :id,
                    :name,
                    :address,
                    :phone,
                    :bank_name,
                    :bank_address,
                    :bank_swift_code,
                    :bank_account_name,
                    :bank_account_number
                  ]
    )
  end

  def load_summary(restaurant_ids)
    total_restaurants = restaurant_ids.size
    total_kitchens    = Kitchen.where(restaurant_id: restaurant_ids).count
    total_suppliers   = Supplier.where(restaurant_id: restaurant_ids).count
    total_food_items  = FoodItem.where(restaurant_id: restaurant_ids).count
    pending_orders = Order.where(restaurant_id: restaurant_ids).where(status: [:placed, :accepted])
    shipped_orders = Order.where(restaurant_id: restaurant_ids).where(status: [:delivered])

    @summary = [
      { type: 'suppliers', count: total_suppliers,   description: "Suppliers" },
      { type: 'pending_pos', count: "#{pending_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(pending_orders.price)} PENDING" },
      { type: 'shipped_pos', count: "#{shipped_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(shipped_orders.price)} SHIPPED" },
      { type: 'food_items', count: total_food_items,  description: "Food Items" },
      # { type: 'kitchens', count: total_kitchens,    description: "Kitchens" }, 
    ]

    @summary.unshift({ count: total_restaurants, description: "Restaurants" }) if total_restaurants != 1
  end
end