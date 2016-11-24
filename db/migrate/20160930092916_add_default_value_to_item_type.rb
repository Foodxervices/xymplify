class AddDefaultValueToItemType < ActiveRecord::Migration
  def change
    change_column_default :food_items, :type, "Others"
  end
end
