class FoodItemsController < ApplicationController
  helper_method :sort_column, :sort_direction

  load_and_authorize_resource :restaurant
  load_and_authorize_resource :food_item, :through => :restaurant, :shallow => true

  def index
    @food_item_filter = FoodItemFilter.new(@food_items, food_item_filter_params)
    @food_items =  @food_item_filter.result
                                    .select('food_items.*, suppliers.name as supplier_name, kitchens.name as kitchen_name')
                                    .includes(:supplier, :kitchen)
                                    .order(sort_column + ' ' + sort_direction)
                                    .paginate(:page => params[:page])
  end

  def show; end

  def new 
    @food_item = FoodItem.new(unit_price_currency: "")
  end

  def create
    if @food_item.save
      redirect_to [@restaurant, :food_items], notice: 'Food Item has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @food_item.update_attributes(food_item_params)
      redirect_to [@food_item.restaurant, :food_items], notice: 'Food Item has been updated.'
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
      :kitchen_id,
    )
  end

  def food_item_params
    data = params.require(:food_item).permit(
      :code,
      :name,
      :unit,
      :unit_price,
      :unit_price_currency,
      :supplier_id,
      :kitchen_id,
      :brand,
      :image,
      :type
    )
    data[:kitchen_id] = Kitchen.accessible_by(current_ability).find(data[:kitchen_id]).id if data[:kitchen_id].present?
    data[:user_id] = current_user.id
    data
  end
  
  def sort_column
    FoodItem.column_names
            .push('supplier_name')
            .push('kitchen_name')
            .include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end