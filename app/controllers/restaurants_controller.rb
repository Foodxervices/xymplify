class RestaurantsController < ApplicationController
  before_action :disable_bullet, only: [:show]
  load_and_authorize_resource 

  def index
    respond_to do |format|
      format.html do
        @restaurant_filter = RestaurantFilter.new(restaurant_filter_params)
        @restaurants  = @restaurant_filter.result
                                          .accessible_by(current_ability)
        redirect_to @restaurants.first if @restaurants.size == 1                                          
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
    @activities = Version.by_restaurant(@restaurant.id)
                             .includes(:item)
                             .paginate(:page => params[:activity_page], :per_page => 5)

    @alerts = Alert.accessible_by(current_ability, restaurant: @restaurant)
                   .includes(:alertable)
                   .paginate(:page => params[:alert_page], :per_page => 5)
                   .order(id: :desc)
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
end