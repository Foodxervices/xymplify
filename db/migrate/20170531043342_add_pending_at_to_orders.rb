class AddPendingAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pending_at, :datetime
  end
end
