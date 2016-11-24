class RemoveKitchenId < ActiveRecord::Migration
  def change
    remove_column :food_items, :kitchen_id
  end
end
