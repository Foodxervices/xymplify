class RenameDeliveryAt < ActiveRecord::Migration
  def change
    rename_column :orders, :delivery_at, :delivered_at
  end
end
