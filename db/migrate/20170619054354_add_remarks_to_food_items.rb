class AddRemarksToFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :remarks, :text
  end
end
