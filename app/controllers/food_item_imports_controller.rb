class FoodItemImportsController < ApplicationController
  layout false
  
  def new
    @food_item_import = FoodItemImport.new
  end

  def create; end
end
