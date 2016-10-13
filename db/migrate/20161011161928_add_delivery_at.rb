class AddDeliveryAt < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_at, :datetime
  end
end
