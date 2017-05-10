class RestaurantsController < AdminController
  before_action :clear_restaurant_sessions, only: [:index]
  before_action :set_session
  before_action :disable_bullet, only: [:show, :index, :dashboard]
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html do
        @restaurant_filter = RestaurantFilter.new(restaurant_filter_params)
        @restaurants  = @restaurant_filter.result
                                          .accessible_by(current_ability)
        if !current_user.kind_of?(Admin) && @restaurants.size == 1 && !params[:restaurant_filter]
          restaurant = @restaurants.first
          kitchens = restaurant.kitchens.accessible_by(current_ability)

          if kitchens.size == 1
            kitchen = kitchens.first
            session[:restaurant_id] = kitchen.restaurant_id
            redirect_to [:dashboard, kitchen]
          else
            redirect_to [:dashboard, restaurant]
          end
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
      redirect_to :back, notice: 'Restaurant has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @restaurant.update_attributes(restaurant_params)
      redirect_to :back, notice: 'Restaurant has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @restaurant.destroy
      session.delete(:restaurant_id)
      flash[:notice] = 'Restaurant has been deleted.'
    else
      flash[:notice] = @restaurant.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  def dashboard
    session.delete(:kitchen_id)
    alerts = Alert.accessible_by(current_ability, restaurant: @restaurant)
                                .includes(:alertable)
                                .order(id: :desc)

    @alerts              = alerts.where.not(type: :incoming_delivery).paginate(:page => params[:alert_page], :per_page => 5)
    @incoming_deliveries = alerts.where(type: :incoming_delivery).paginate(:page => params[:incoming_page], :per_page => 5)

    @messages = @restaurant.messages.accessible_by(current_ability).order(id: :desc).paginate(:page => params[:message_page], :per_page => 5)

    @notification = Notification.new(current_ability, current_restaurant, current_user)

    @display_more_activity_link = true
    load_summary([@restaurant.id])
  end

  private

  def set_session
    session[:restaurant_id] = params[:id].to_i if params[:id]
  end

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
      :block_delivery_dates,
      receive_email: []
    )
  end

  def load_summary(restaurant_ids)
    orders = Order.where(restaurant_id: restaurant_ids)
    shipped_orders = orders.where(status: [:delivered, :completed])
    total_suppliers   = Supplier.where(restaurant_id: restaurant_ids).count
    total_food_items  = FoodItem.where(restaurant_id: restaurant_ids).count

    @summary = []

    if action_name == 'index'
      total_restaurants = restaurant_ids.size
      total_kitchens    = Kitchen.where(restaurant_id: restaurant_ids).count
      total_users       = UserRole.where(restaurant_id: restaurant_ids).select(:user_id).uniq.size


      @summary = [
        { type: 'restaurants', count: total_restaurants, description: "Restaurants" },
        { type: 'kitchens',    count: total_kitchens,    description: "Kitchens" },
        { type: 'users',       count: total_users,       description: "User Accounts" },
        { type: 'suppliers',   count: total_suppliers,   description: "Suppliers" },
        { type: 'food_items',  count: total_food_items,  description: "Food Items" },
        { type: 'shipped_pos', count: "#{shipped_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(shipped_orders.price)} DELIVERED" }
      ]
    else
      pending_orders = orders.where(status: [:placed, :accepted])

      @summary = [
        { type: 'suppliers',   count: total_suppliers,   description: "Suppliers" },
        { type: 'food_items',  count: total_food_items,  description: "Food Items" },
        { type: 'pending_pos', count: "#{pending_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(pending_orders.price)} PENDING" },
        { type: 'shipped_pos', count: "#{shipped_orders.size} <small>POs</small>",  description: "#{ActionController::Base.helpers.humanized_money_with_symbol(shipped_orders.price)} DELIVERED" }
      ]
    end
  end
end