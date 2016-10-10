class AddTagListToFoodItems < ActiveRecord::Migration
  def change
    remove_column :food_items, :type, :string 
    add_column :food_items, :cached_tag_list, :string, default: ''
  end
end
