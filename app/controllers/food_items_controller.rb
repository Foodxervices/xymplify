class FoodItemsController < ApplicationController
  def index
    @food_items = FoodItem.all
  end

  def new
    @food_item = FoodItem.new
  end

  def create
    @food_item = FoodItem.new(food_item_params)

    if @food_item.save
      redirect_to food_items_url, notice: 'Food Item has been created.'
    else
      render :new
    end
  end

  def edit
    @food_item = FoodItem.find(params[:id])
  end

  private

  def food_item_params
    params.require(:food_item).permit(
        :code,
        :name,
        :unit,
        :unit_price
      )
  end
end