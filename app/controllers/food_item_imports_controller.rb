class FoodItemImportsController < ApplicationController
  load_and_authorize_resource :restaurant

  def new
    @food_item_import = FoodItemImport.new(kitchen_ids: [current_kitchen&.id])
  end

  def create
    @food_item_import = FoodItemImport.new(food_item_import_params)

    begin
      ActiveRecord::Base.transaction do
        if @food_item_import.save
          @warnings = @food_item_import.errors[:warning]
          render :success
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
      :file,
      :supplier_id,
      kitchen_ids: []
    )
    data[:restaurant_id] = @restaurant.id
    data[:user_id] = current_user.id

    if data[:supplier_id].present?
      data[:supplier_id] = @restaurant.suppliers.find(data[:supplier_id]).id
    end

    if data[:kitchen_ids].present?
      data[:kitchen_ids] = @restaurant.kitchens.accessible_by(current_ability, :import).where(id: data[:kitchen_ids]).pluck(:id)
    end
    
    data
  end
end
