class FoodItemsController < ApplicationController
  load_and_authorize_resource

  def index
    @food_items = FoodItem.all
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

  def food_item_params
    params.require(:food_item).permit(
        :code,
        :name,
        :unit,
        :unit_price,
        :supplier_id,
      )
  end
end