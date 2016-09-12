class AddBrandToFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :brand, :string
  end
end
