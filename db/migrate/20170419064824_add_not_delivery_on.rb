class AddNotDeliveryOn < ActiveRecord::Migration
  def change
    add_column :restaurants, :block_delivery_dates, :text
    change_column :suppliers, :block_delivery_dates, :text
  end
end
