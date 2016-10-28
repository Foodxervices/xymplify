class FoodItemImportsController < ApplicationController
  load_and_authorize_resource :restaurant

  def new
    @food_item_import = FoodItemImport.new
  end

  def create
    @food_item_import = FoodItemImport.new(food_item_import_params)

    begin
      ActiveRecord::Base.transaction do
        if @food_item_import.save
        redirect_to :back
        else
          @errors = @food_item_import.errors[:import]
          render :new
        end
      end
    rescue Exception => error
      @food_item_import.errors[:file] = error
      render :new
    end
  end

  private

  def food_item_import_params
    data = params.require(:food_item_import).permit(
      :kitchen_id,
      :file
    )
    if data[:kitchen_id].present?
      kitchen = current_restaurant.kitchens.find(data[:kitchen_id])
      authorize! :import, kitchen
      data[:kitchen_id] = kitchen.id
    end
    data[:user_id] = current_user.id
    data
  end
end
