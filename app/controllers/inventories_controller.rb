class InventoriesController < ApplicationController
  load_and_authorize_resource :food_item, parent: false

  def index
    @food_item_filter = FoodItemFilter.new(food_item_filter_params)
    @food_items = @food_item_filter.result.order(:id).includes(:supplier, :chicken).paginate(:page => params[:page])
    @groups = {}
    @food_items.each do |food_item|
      @groups[food_item.name] ||= []
      @groups[food_item.name] << {
        id: food_item.id,
        name: food_item.name,
        supplier_name: food_item.supplier&.name,
        current_quantity: food_item.current_quantity,
        quantity_ordered: food_item.quantity_ordered,
        unit: food_item.unit,
        unit_price: food_item.unit_price,
        chicken_name: food_item.chicken&.name
      }
    end
  end

  def update_current_quantity
    @food_item.update_attributes(update_current_quantity_params)
    render json: @food_item.reload 
  end

  private 

  def update_current_quantity_params
    params.require(:food_item).permit(
      :current_quantity
    )
  end

  def food_item_filter_params
    food_item_filter = ActionController::Parameters.new(params[:food_item_filter])
    food_item_filter.permit(
      :keyword,
      :chicken_id,
    )
  end
end