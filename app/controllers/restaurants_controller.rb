class RestaurantsController < ApplicationController
  load_and_authorize_resource 

  def index
    @restaurant_filter = RestaurantFilter.new(restaurant_filter_params)
    @restaurants  = @restaurant_filter.result
                                      .accessible_by(current_ability)
                                      .includes(:kitchens)
                                      .paginate(:page => params[:page])
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
      kitchens_attributes: [
                    :id,
                    :name,
                    :bank_name,
                    :bank_address,
                    :bank_swift_code,
                    :bank_account_name,
                    :bank_account_number
                  ]
    )
  end
end