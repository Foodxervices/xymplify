class AddLowQuantity < ActiveRecord::Migration
  def change
    add_column :food_items, :low_quantity, :decimal, precision: 8, scale: 2
  end
end
