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
    if data[:kitchen_id].present?
      kitchen = Kitchen.find(data[:kitchen_id])
      authorize! :import, kitchen
      data[:kitchen_id] = kitchen.id
    end
    data[:user_id] = current_user.id
    data
  end
end
