class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :supplier, index: true 
      t.belongs_to :kitchen, index: true 
    end

    create_table :order_items do |t|
      t.monetize :unit_price
      t.integer :quantity
      t.belongs_to :order, index: true 
      t.belongs_to :food_item, index: true 
    end
  end
end
