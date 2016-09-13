class AddImageToFoodItems < ActiveRecord::Migration
  def change
    add_attachment :food_items, :image
  end
end
