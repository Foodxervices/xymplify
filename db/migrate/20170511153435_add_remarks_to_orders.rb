class AddRemarksToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :eatery_remarks, :text
  end
end
