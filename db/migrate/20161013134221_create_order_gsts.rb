class CreateOrderGsts < ActiveRecord::Migration
  def change
    create_table :order_gsts do |t|
      t.string :name 
      t.decimal :percent, precision: 4, scale: 2, default: 0.0
      t.monetize :amount
      t.belongs_to :order, index: true
      t.belongs_to :restaurant, index: true
    end
  end
end
