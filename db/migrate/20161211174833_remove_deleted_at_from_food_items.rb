class RemoveDeletedAtFromFoodItems < ActiveRecord::Migration
  def change
    remove_column :food_items, :deleted_at, :datetime
  end
end
