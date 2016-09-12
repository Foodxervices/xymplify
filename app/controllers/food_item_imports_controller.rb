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
    data = params.require(:food_item_import).permit(:file)
    data[:user_id] = current_user.id
    data
  end
end
