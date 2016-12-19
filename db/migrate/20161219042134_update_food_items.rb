class UpdateFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :deleted_at, :datetime
    add_index :food_items, :deleted_at
  end
end
