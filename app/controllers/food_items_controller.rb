class FoodItemsController < ApplicationController
  load_and_authorize_resource

  def index
    @food_item_filter = FoodItemFilter.new(food_item_filter_params)
    @food_items = @food_item_filter.result.includes(:supplier).paginate(:page => params[:page])
  end

  def new; end

  def create
    if @food_item.save
      redirect_to food_items_url, notice: 'Food Item has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @food_item.update_attributes(food_item_params)
      redirect_to food_items_url, notice: 'Food Item has been updated.'
    else
      render :edit
    end
  end

  def destroy
    @food_item.destroy
    redirect_to :back, notice: 'Food Item has been deleted.'
  end

  private

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    food_item_filter.permit(
      :keyword,
    )
  end

  def food_item_params
    data = params.require(:food_item).permit(
      :code,
      :name,
      :unit,
      :unit_price,
      :supplier_id,
      :brand
    )
    data[:user_id] = current_user.id
    data
  end
end