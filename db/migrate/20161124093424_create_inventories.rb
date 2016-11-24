class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.belongs_to :restaurant, index: true
      t.belongs_to :kitchen, index: true
      t.belongs_to :food_item, index: true
      t.decimal :current_quantity, precision: 8, scale: 2, default: 0.0
      t.decimal :quantity_ordered, precision: 8, scale: 2, default: 0.0
    end

    FoodItem.all.includes(:kitchens, :restaurant).each do |food_item|
      food_item.kitchens.each do |kitchen|
        if food_item.current_quantity != 0 || food_item.quantity_ordered != 0
          Inventory.create(food_item: food_item, kitchen: kitchen, restaurant: food_item.restaurant, current_quantity: food_item.current_quantity, quantity_ordered: food_item.quantity_ordered)
        end
      end
    end
  end
end
