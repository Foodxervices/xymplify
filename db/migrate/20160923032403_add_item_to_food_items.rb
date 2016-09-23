class AddItemToFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :type, :string
  end
end
