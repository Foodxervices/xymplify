class AddDefaultValueToItemType < ActiveRecord::Migration
  def change
    change_column_default :food_items, :type, "Others"

    FoodItem.where(type: [nil, ""]).update_all(type: "Others")
  end
end
