class AddOrderedCount < ActiveRecord::Migration
  def change
    add_column :food_items, :ordered_count, :integer, default: 0
    add_index :food_items, :ordered_count
    add_index :categories, :priority
    add_index :suppliers, :priority
  end
end
