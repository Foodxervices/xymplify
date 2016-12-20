class AddMoqToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :min_order_price, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :suppliers, :max_order_price, :decimal, precision: 12, scale: 2
  end
end