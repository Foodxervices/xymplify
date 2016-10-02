class RemoveBrandIdFromFoodItems < ActiveRecord::Migration
  def change
    remove_column :food_items, :brand_id, :integer
  end
end
