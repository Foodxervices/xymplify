class AddIndexToFoodItemCode < ActiveRecord::Migration
  def change
    add_index :food_items, :code
  end
end
