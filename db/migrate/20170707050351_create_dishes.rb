class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :name
      t.belongs_to :restaurant, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end

    create_table :dish_items do |t|
      t.belongs_to :food_item, index: true 
      t.belongs_to :dish, index: true 
      t.decimal :quantity, precision: 8, scale: 2, default: 0.0
      t.timestamps
    end
  end
end
