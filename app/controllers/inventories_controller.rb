class InventoriesController < ApplicationController
  load_and_authorize_resource :food_item, parent: false

  def index
    @food_items = @food_items.order(:id).includes(:supplier)
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
end