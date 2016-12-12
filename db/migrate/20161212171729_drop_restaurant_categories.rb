class DropRestaurantCategories < ActiveRecord::Migration
  def change
    drop_table :restaurant_categories
    remove_column :food_items, :restaurant_category_id
  end
end
