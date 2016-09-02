class CreateFoodItems < ActiveRecord::Migration
  def change
    create_table :food_items do |t|
      t.string :name
      t.string :code 
      t.string :unit 
      t.decimal :unit_price, precision: 12, scale: 2, default: 0.0
      t.belongs_to :supplier, index: true
    end
  end
end
