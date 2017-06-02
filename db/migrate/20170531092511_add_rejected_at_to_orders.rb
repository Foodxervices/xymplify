class AddRejectedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rejected_at, :datetime
  end
end
