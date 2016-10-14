class AddGstsCountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :gsts_count, :integer, :default => 0

    Order.reset_column_information
    Order.all.each do |o|
      Order.update_counters o.id, :gsts_count => o.gsts.length
    end
  end
end
