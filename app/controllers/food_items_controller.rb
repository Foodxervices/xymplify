class FoodItemsController < ApplicationController
  def index
    @food_items = FoodItem.all
  end

  def new
    @food_item = FoodItem.new
  end
end