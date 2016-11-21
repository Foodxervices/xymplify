class AddIndexToRequestForDeliveryAt < ActiveRecord::Migration
  def change
    add_index :orders, :request_for_delivery_at
  end
end
