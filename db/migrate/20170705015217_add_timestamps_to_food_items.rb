class AddTimestampsToFoodItems < ActiveRecord::Migration
  def change
    add_timestamps :food_items, null: false, default: DateTime.now

    FoodItem.all.each do |f|
      next if !f.versions.first&.created_at
      f.update_columns(created_at: f.versions.first.created_at, updated_at: f.versions.last.created_at)
    end
  end
end
