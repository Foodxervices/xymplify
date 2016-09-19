class AddKitchenIdToFoodItems < ActiveRecord::Migration
  def change
    add_reference :food_items, :kitchen, index: true
  end
end
