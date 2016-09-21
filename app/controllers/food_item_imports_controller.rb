class FoodItemImportsController < ApplicationController
  def new
    @food_item_import = FoodItemImport.new
  end

  def create
    @food_item_import = FoodItemImport.new(food_item_import_params)
    @success = @food_item_import.save
  end

  private

  def food_item_import_params
    data = params.require(:food_item_import).permit(
      :kitchen_id,
      :file
    )
    data[:kitchen_id] = Kitchen.accessible_by(current_ability).find(data[:kitchen_id]).id if data[:kitchen_id].present?
    data[:user_id] = current_user.id
    data
  end
end
