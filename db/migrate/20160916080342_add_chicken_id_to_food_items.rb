class AddChickenIdToFoodItems < ActiveRecord::Migration
  def change
    add_reference :food_items, :chicken, index: true
  end
end
