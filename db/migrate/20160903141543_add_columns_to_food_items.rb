class AddColumnsToFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :current_quantity, :integer, default: 0
    add_column :food_items, :quantity_ordered, :integer, default: 0
  end
end
